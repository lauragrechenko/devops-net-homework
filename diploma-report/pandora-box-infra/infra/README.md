# PandoraBox deployment

Helm chart and supporting manifests for deploying PandoraBox into a Kubernetes cluster set up via the [infra-pandora-box](https://gitlab.com/laura.grechenko.erlang-group/infra-pandora-box) runbook. Cluster bring-up, addons (ESO / CSI / Gateway / Monitoring), and infra-side secrets (Lockbox + ESO) all live in that repo.

```
infra/
├── helm/pandora-box/   # Helm chart
├── k8s/                # standalone manifests
└── otel/               # OpenTelemetry collector config
```

## Prerequisites

The target cluster must already have (per the infra-repo runbook):

- **GitLab Agent** `pandora-k8s` registered in `infra-pandora-box`, with this project listed in its `ci_access` (`.gitlab/agents/pandora-k8s/config.yaml` in the infra repo).
- **External Secrets Operator** with `pandora-box/backups-s3` and `pandora-box/yc-registry` `ExternalSecret`s in `SecretSynced` — synced from YC Lockbox.
- **YC Disk CSI driver** with `yc-network-hdd` as default `StorageClass`.
- **Envoy Gateway** with the cluster-wide `public` `Gateway`.

## Container images

Two Dockerfiles, two registry tags:

| Dockerfile | Image | Built by |
|---|---|---|
| `Dockerfile.rocksdb` | `$IMAGE_REPO-rocksdb:latest` (+ `:buildcache`) | `build:rocksdb-cache` (manual) |
| `Dockerfile` | `$IMAGE_REPO:$CI_COMMIT_SHORT_SHA` | `build:image` (manual) |

The RocksDB NIF is the heavy part of the build: it pulls a C toolchain (build-base, cmake, snappy/zlib/bzip2/lz4/zstd dev headers) and compiles RocksDB from source. To keep the per-commit `build:image` fast, that work is done once in `Dockerfile.rocksdb` and pushed as a separate cache image. `Dockerfile` then pulls the pre-compiled NIF in via `--build-arg ROCKSDB_CACHE_IMAGE=...` and `--mount=from=rocksdb-cache` (see [Dockerfile:6-7,66-70](../Dockerfile)), so the app build skips the toolchain entirely.

Rebuild `build:rocksdb-cache` only when the `rocksdb` entry in `mix.lock` changes (or you bump the cache key suffix in `.gitlab-ci.yml`). Day-to-day commits only run `build:image`.

## Secret ownership

The StatefulSet consumes three Secrets in the `pandora-box` namespace:

| Secret | Owner | Source |
|---|---|---|
| `pandora-box` | CI `deploy` job | 5 app CI vars (below) |
| `backups-s3` | ESO | YC Lockbox `pandora-box-backups-s3` (populated by infra `pandora-box/` TF) |
| `yc-registry` | ESO | YC Lockbox `pandora-box-cr-pull` (populated by infra `bootstrap/` TF) |

CI never touches the ESO-owned Secrets; ESO never touches the CI-owned one.

## CI variables

Set on this project (Settings → CI/CD → Variables; all Masked + Protected):

| Var | What |
|---|---|
| `SECRET_KEY_BASE` | Phoenix secret key base |
| `API_TOKEN_PEPPER` | API token hashing pepper |
| `RELEASE_COOKIE` | Erlang distribution cookie |
| `PANDORA_KEK` | Key encryption key |
| `PBX_INIT_SECRET` | App init secret |

These are operator-owned. Bootstrap doesn't touch them; rotate when you want, on your schedule.

**After every infra from-scratch bootstrap**, refresh these two non-secret CI variables (Settings → CI/CD → Variables; Variable type, not Masked — they're public IDs):

- `IMAGE_REPO` — set to `cr.yandex/$(terraform -chdir=<infra-repo>/infra/terraform/yc/bootstrap output -raw registry_id)/pandora_box`.
- `YC_SA_ID` — the new pandora_box CI SA ID from the same bootstrap outputs.

**After every `infra/terraform/yc/main` apply that re-creates the ingress NLB**, refresh the public hostname in `infra/helm/pandora-box/values-prod.yaml`:

- `phoenix.host` — set to the new ingress NLB IP: `terraform -chdir=<infra-repo>/infra/terraform/yc/main output -raw ingress_lb_ip`. This becomes `PHX_HOST` in the StatefulSet env; Phoenix uses it both for generated URLs and for the default `check_origin` rule on the LiveView socket. If it's stale, requests to the actual NLB IP get rejected with `Could not check origin`, and LiveView pages (e.g. `/bootstrap`) fail to mount. Commit + push the change so the next CI `deploy` keeps it in sync; for an immediate fix you can also `kubectl -n pandora-box set env statefulset/pandora-box PHX_HOST=<new-ip>`.

## Local dev (minikube)

Build the RocksDB cache image once (rebuild only when the `rocksdb` entry in `mix.lock` changes), then build the app image against it. The app build mounts the pre-compiled NIF in via `--build-arg ROCKSDB_CACHE_IMAGE=...` and skips the C toolchain.

```bash
# 1. Heavy build — once. Compiles RocksDB from source.
docker build -f Dockerfile.rocksdb -t internal/pandora_box-rocksdb:dev .

# 2. App image — fast, reuses the cached NIF from step 1.
docker build \
  --build-arg ROCKSDB_CACHE_IMAGE=internal/pandora_box-rocksdb:dev \
  -t internal/pandora_box:dev .

minikube image load internal/pandora_box:dev   # if built outside minikube
helm upgrade --install pandora-box infra/helm/pandora-box \
  -n pandora-box --create-namespace \
  -f infra/helm/pandora-box/values-local.yaml
```

`values-local.yaml` keeps `secrets.create=true`, so the chart renders both `pandora-box` and `backups-s3` Secrets in-cluster from the defaults in `values.yaml` (minio creds). No ESO, no Lockbox.

## Production deploy

Push to `master` triggers the `deploy` job (see [.gitlab-ci.yml](../.gitlab-ci.yml)). Auth goes through the GitLab Agent kubeconfig context. The chart is rendered with `secrets.create=false`, so it trusts CI to materialise `pandora-box` and ESO to materialise `backups-s3` + `yc-registry`.
