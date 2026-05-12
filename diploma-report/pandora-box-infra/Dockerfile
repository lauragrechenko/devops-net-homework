# =========
# RocksDB cache stage — pre-compiled NIF from Dockerfile.rocksdb.
# Falls back to scratch (empty) when ROCKSDB_CACHE_IMAGE is not set,
# which means a full RocksDB build inside the main build stage.
# =========
ARG ROCKSDB_CACHE_IMAGE=scratch
FROM ${ROCKSDB_CACHE_IMAGE} AS rocksdb-cache

# =========
# Build stage
# =========
FROM elixir:1.19.3-alpine AS build

WORKDIR /app

# ---- Build deps ----
RUN apk add --no-cache \
  build-base \
  linux-headers \
  git \
  cmake \
  snappy-dev \
  zlib-dev \
  bzip2-dev \
  lz4-dev \
  zstd-dev \
  nodejs \
  npm \
  # picosat_elixir expects glibc-style sys/unistd.h
  && mkdir -p /usr/include/sys \
  && ln -sf /usr/include/unistd.h /usr/include/sys/unistd.h

# ---- Speed knobs (parallel C/C++ builds) ----
# Override with: --build-arg BUILD_CORES=$(nproc)
ARG BUILD_CORES=4
ENV MAKEFLAGS="-j${BUILD_CORES}" \
    CMAKE_BUILD_PARALLEL_LEVEL="${BUILD_CORES}" \
    NIF_BUILD_MAKE_JOBS="${BUILD_CORES}" \
    MIX_ENV=prod

RUN mix local.hex --force && mix local.rebar --force

# ---- Copy ONLY dependency manifests first (better Docker cache) ----
COPY mix.exs mix.lock ./

COPY apps/demo/mix.exs apps/demo/mix.exs
COPY apps/pandora_box_storage/mix.exs apps/pandora_box_storage/mix.exs
COPY apps/pandora_box_backend_relational/mix.exs apps/pandora_box_backend_relational/mix.exs
COPY apps/pandora_box_backend_sqlite/mix.exs apps/pandora_box_backend_sqlite/mix.exs
COPY apps/pandora_box_backend_mnesia/mix.exs apps/pandora_box_backend_mnesia/mix.exs
COPY apps/pandora_box_backend_rocksdb/mix.exs apps/pandora_box_backend_rocksdb/mix.exs
COPY apps/pandora_box_identity/mix.exs apps/pandora_box_identity/mix.exs
COPY apps/pandora_box_abyss/mix.exs apps/pandora_box_abyss/mix.exs
COPY apps/pandora_box_lid/mix.exs apps/pandora_box_lid/mix.exs
COPY apps/pandora_box_portal/mix.exs apps/pandora_box_portal/mix.exs
COPY apps/pandora_box_core/mix.exs apps/pandora_box_core/mix.exs
COPY apps/pandora_box_crypto/mix.exs apps/pandora_box_crypto/mix.exs
COPY apps/pandora_box_audit/mix.exs apps/pandora_box_audit/mix.exs
COPY apps/pandora_box_telemetry/mix.exs apps/pandora_box_telemetry/mix.exs
COPY apps/system_tests/mix.exs apps/system_tests/mix.exs

# Fetch + compile deps (cached unless mix files change)
RUN mix deps.get --only prod

# Restore pre-compiled RocksDB NIF from cache image (no-op when scratch)
RUN --mount=from=rocksdb-cache,source=/,target=/rocksdb-cache \
    if [ -d /rocksdb-cache/app/deps/rocksdb/_build ]; then \
      cp -a /rocksdb-cache/app/deps/rocksdb/_build deps/rocksdb/_build && \
      cp -a /rocksdb-cache/app/deps/rocksdb/priv   deps/rocksdb/priv && \
      find deps/rocksdb/_build deps/rocksdb/priv -type f -exec touch {} + ; \
    fi

RUN mix deps.compile

# ---- Now copy the rest (won't invalidate deps layer) ----
COPY config/ config/
COPY apps apps
COPY rel rel
COPY clusters.yml clusters.yml

# ---- Build Phoenix assets ----
RUN mix assets.deploy --app pandora_box_lid

RUN mix compile
RUN mix release pandora_box


# =========
# Runtime stage
# =========
FROM alpine:3.22 AS runtime

# Minimal runtime deps for Erlang/Elixir releases
# snappy lz4-libs zstd-libs are needed by the RocksDB NIF at runtime
RUN apk add --no-cache openssl ncurses-libs libstdc++ sqlite \
  snappy lz4-libs zstd-libs

WORKDIR /app

COPY --from=build /app/_build/prod/rel/pandora_box ./
COPY --from=build /app/clusters.yml /app/clusters.yml

ENV MIX_ENV=prod \
    RELEASE_DISTRIBUTION=sname \
    RELEASE_NODE=pandora_box@127.0.0.1 \
    RELEASE_COOKIE=pandora_cookie \
    PHX_SERVER=true

CMD ["bin/pandora_box", "start"]
