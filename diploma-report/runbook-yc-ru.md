# Runbook инфраструктуры (YC)

```
infra/
├── terraform/yc/
│   ├── bootstrap/     # state-бакет, KMS, SAs, container registry, Lockboxes (применяется с ноутбука)
│   ├── platform/      # VPC, подсети, NAT, atlantis SG, Atlantis VM + NLB (CI: bringup:platform)
│   ├── main/          # bastion, k8s VMs, ingress NLB (Atlantis-managed)
│   └── pandora-box/   # backups-бакет + scoped SA для приложения PandoraBox (Atlantis-managed)
├── ansible/kubespray/   # установка k8s
├── k8s/
│   ├── csi/v1.2.0/      # манифесты YC Disk CSI driver (vendored)
│   ├── eso/             # манифесты External Secrets Operator (Lockbox → k8s Secret sync)
│   ├── gateway/         # Envoy Gateway Helm values + Gateway/GatewayClass
│   └── monitoring/      # Helm values + Grafana Ingress для kube-prometheus-stack
└── scripts/
```

Последовательность развёртывания:

```
bootstrap (локально)
    │
    ▼
platform (CI ▶ bringup:platform)
    │
    ▼
main (Atlantis MR)
    │
    ▼
kubespray (локально)
    │
    ▼
addons (CI ▶ addons)
```

На этапе bootstrap создаются bucket для state и сервисные аккаунты, от которых зависят все остальные модули, - поэтому первый запуск `bootstrap apply` выполняется локально под *личными* учётными данными администратора; все дальнейшие операции идут уже под созданными сервисными аккаунтами. Корневой модуль `platform/` - единственный, который CI применяет напрямую: запуск Atlantis.

### Настройка shell (direnv)

Все команды ниже предполагают, что в shell загружены три переменные:
- `$REPO_ROOT` - абсолютный путь к репозиторию с кодом инфраструктуры.
- `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` - статические ключи, созданные на этапе bootstrap (используются всеми последующими вызовами `terraform` для работы с S3-бэкендом)

Переменные загружаются через [direnv](https://direnv.net):
- `.envrc` (находится в репозитории) экспортирует `REPO_ROOT="$PWD"` и подключает `.envrc.local` через `source`.
- `.envrc.local` (исключён через `.gitignore`) хранит `AWS_*`. На запрос bootstrap-скрипта (шаг 1a) следует ответить `y` - после этого скрипт запишет ключи автоматически.

**Однократная настройка**, если direnv ещё не установлен:

```bash
brew install direnv
echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc   # или ~/.bashrc
exec zsh                                        # перезагрузить shell
cd <repo>; direnv allow                         # благословить .envrc
```

После этого каждый shell, переходящий в каталог репозитория командой `cd`, автоматически получает `REPO_ROOT` и `AWS_*`. При выходе из каталога переменные сбрасываются.

**Без direnv** (ручная альтернатива): в каждом shell нужно выполнить `export REPO_ROOT=$(git rev-parse --show-toplevel) && source "$REPO_ROOT/.envrc.local"`.

---

## 0. Однократные предварительные требования
- Установлен `yc` CLI и выполнена команда `yc init` (даёт `cloud_id` и `folder_id`).
- Личный пользователь YC IAM с правами admin (используется только для самого первого запуска `bootstrap apply`). Роль `folder-admin` неявно предоставляет также права чтения и записи payload во всех Lockbox, создаваемых на этапе bootstrap, - включая Lockbox `atlantis-operator-ip`, который заполняется вручную на шаге 2a.

## 1. Bootstrap (создание state-bucket, SA, registry и Lockboxes)

### 1a. С нуля (выполняется один раз)

State-bucket ещё не существует, поэтому S3-бэкенд нельзя инициализировать - Terraform должен сначала применить изменения локально, а затем мигрировать state в созданный bucket. Скрипт автоматизирует этот процесс:

```bash
export YC_TOKEN=$(yc iam create-token)
"$REPO_ROOT/infra/scripts/bootstrap-from-scratch.sh"
```

Скрипт:
- удаляет `.terraform/` и `terraform.tfstate*`, оставшиеся после предыдущего destroy;
- очищает устаревшие переменные `AWS_*` в shell (старые ключи bootstrap приводят к ошибке `403 AccessDenied` при создании нового `yandex_storage_bucket`);
- временно отключает `backend.tf` и выполняет `terraform apply` с локальным state;
- сохраняет учётные данные статического ключа в `~/.config/pandora-box/bootstrap-creds.env` (chmod 600);
- восстанавливает `backend.tf` и выполняет `terraform init -migrate-state` для переноса state в S3;
- предлагает (запрос `[y/N]`) записать ключи в `$REPO_ROOT/.envrc.local`, чтобы их автоматически загружал direnv.

**Статический `secret_key` отображается ровно один раз.** Прежде чем удалять файл с учётными данными, необходимо убедиться, что ключ сохранён во всех трёх постоянных местах хранения:
1. `direnv` - `$REPO_ROOT/.envrc.local` (исключён через `.gitignore`). Скрипт предложит сохранить ключи автоматически; после этого однократно выполняется `direnv allow`.
2. Переменные GitLab CI - `AWS_ACCESS_KEY_ID` и `AWS_SECRET_ACCESS_KEY` (Masked + Protected). **Также необходимо обновить `YC_SA_ID`** значением, выведенным скриптом (ID bootstrap-SA изменяется при каждом запуске «с нуля» - со старым значением каждое CI-job будет завершаться ошибкой 401 при обмене YC OIDC token). `YC_FOLDER_ID` достаточно установить однократно, если каталог (folder) не менялся.
3. Запись в менеджере паролей в качестве резервной копии.

Если этот шаг пропущен и ключи потеряны - см. раздел [Manual escape-hatch](#manual-escape-hatch-когда-export_s3_tfstate_envsh-не-может-прочитать-state) ниже: восстановление возможно. Если `terraform apply` завершился ошибкой в середине процесса (например, из-за ресурса, оставшегося после неполного предыдущего destroy) - см. раздел [Recovery](#recovery-bootstrap-from-scratchsh-упал-на-полпути-в-terraform-apply).

### 1b. Последующие запуски apply

Когда bucket уже существует и `AWS_*` загружены в shell:

```bash
cd "$REPO_ROOT/infra/terraform/yc/bootstrap"
terraform apply
```

Outputs bootstrap используются скриптами далее по этому runbook - ничего копировать вручную не требуется.

### 1c. Получение приватного SSH-ключа для VM (только локальная машина)

На этапе bootstrap генерируется пара ключей ED25519, обе части сохраняются в Lockbox `${name_prefix}-ssh-key` (метка `role=vm-ssh-key`). Корневые модули `platform/` и `main/` читают публичную часть из outputs bootstrap (без обращения к локальному файлу на машине).

```   
# пишет ~/.ssh/id_ed25519_pandora (chmod 600)
"$REPO_ROOT/infra/scripts/fetch_ssh_key.sh"
```

Скрипт идемпотентный - не перезаписывает существующий файл без флага `--force`. Аутентификация выполняется через личный `yc` token (роль `folder-admin`).

CI получает тот же payload из Lockbox непосредственно во время выполнения job - см. шаблон `.fetch-ssh-from-lockbox` в `.gitlab-ci.yml`. SA `gitlab_ci` имеет роль `lockbox.payloadViewer` только на этот единственный Lockbox (per-secret binding в `bootstrap/ssh_key.tf`); SA Atlantis доступа к нему не имеет.

## 2. Проверка, что все четыре backend указывают на новый bucket

Все четыре TF-конфигурации используют общий state-bucket (каждый записывает в собственный `key`). Bootstrap-скрипт синхронизирует имя bucket во **всех четырёх** файлах `backend.tf` в конце шага 1a, но имеет смысл проверить визуально:

```bash
grep -H 'bucket' "$REPO_ROOT"/infra/terraform/yc/{bootstrap,platform,main,pandora-box}/backend.tf
```

Все четыре строки должны вывести одно и то же имя bucket (совпадающее с output `bucket_name` из bootstrap).

Учётные данные `AWS_*` загружаются в shell автоматически через direnv (см. [Настройка shell](#настройка-shell-direnv)). Если они утрачены - см. раздел [Manual escape-hatch](#manual-escape-hatch-когда-export_s3_tfstate_envsh-не-может-прочитать-state).

## 2a. Заполнение Atlantis Lockboxes (operator IP, GitLab token, webhook secret)

Для двух Lockbox требуется заполнить payload, прежде чем Atlantis сможет выполнять операции над корневым модулем `main/`:
- **`atlantis-operator-ip`** - запись `operator_ip`. Заполняется с локальной машины. Читается модулем `main/` при каждом запуске Atlantis plan через data source `yandex_lockbox_secret_version` ([`main/data.tf`](https://gitlab.com/laura.grechenko.erlang-group/infra-pandora-box/-/blob/master/infra/terraform/yc/main/data.tf)).
- **`atlantis-app`** - записи `gitlab_token` и `webhook_secret`. Заполняется через CI. Читается демоном Atlantis при загрузке VM из `/etc/atlantis/app.env`.

Два отдельных хранилища - это сделано намеренно: у них разные источники записи (локальная машина и CI) и разные жизненные циклы. На этапе bootstrap оба хранилища создаются пустыми.

### Заполнение `atlantis-operator-ip` (с локальной машины)

Команда выполняется после `yc init`:
```bash
OP_IP_LOCKBOX_ID=$(terraform -chdir="$REPO_ROOT/infra/terraform/yc/bootstrap" output -raw atlantis_operator_ip_lockbox_id)
yc lockbox secret add-version --id "$OP_IP_LOCKBOX_ID" \
  --payload "[{\"key\":\"operator_ip\",\"text_value\":\"$(curl -s https://api.ipify.org)/32\"}]"
```

Для ротации позже (например, при смене домашнего IP) - повторить ту же команду, затем добавить комментарии `atlantis plan -p main` и `atlantis apply -p main` в MR. Data source обновляется при каждом plan - diff в MR не требуется; сам plan и является обновлением правила SG.

### Заполнение `atlantis-app` (через CI)

**Однократные шаги в GitLab UI** (пропускаются, если уже выполнены):
1. Создать **Personal Access Token** ([User → Preferences → Access Tokens](https://gitlab.com/-/user_settings/personal_access_tokens)) с областью действия (scope) `api`. (Project/Group access tokens были бы предпочтительнее, но не поддерживаются в персональных namespace.)
2. Сгенерировать webhook secret: `openssl rand -hex 32`.
3. Добавить две CI/CD-переменные в репозиторий с инфраструктурой (Project → Settings → CI/CD → Variables):
   - `ATLANTIS_GITLAB_TOKEN` (Masked + Protected) = `glpat-...` из шага 1
   - `ATLANTIS_WEBHOOK_SECRET` (Masked + Protected) = случайная строка из шага 2

**Заполнение через CI:** выполнить push в `master`, открыть свежий pipeline и запустить `seed:atlantis-lockbox`. Оно вызывает Lockbox `addVersion` со значениями заданными в CI variables.

Альтернатива с локальной машины (если CI недоступен):
```bash
LOCKBOX_ID=$(terraform -chdir="$REPO_ROOT/infra/terraform/yc/bootstrap" output -raw atlantis_app_lockbox_id)
yc lockbox secret add-version --id "$LOCKBOX_ID" \
  --payload "[{\"key\":\"gitlab_token\",\"text_value\":\"$ATLANTIS_GITLAB_TOKEN\"},{\"key\":\"webhook_secret\",\"text_value\":\"$ATLANTIS_WEBHOOK_SECRET\"}]"
```

**Ротация:** для замены GitLab token или webhook secret - обновить соответствующую CI-переменную, перезапустить `seed:atlantis-lockbox` в CI, затем выполнить `sudo systemctl restart atlantis-app-env atlantis` на VM (через bastion).

## 3. Развёртывание `platform` через CI

Корневой модуль `platform/` (VPC, subnets, NAT, SG для Atlantis, VM Atlantis, NLB) применяется однократно через ручной job `bringup:platform` на master pipeline. Atlantis не может развернуть сам себя, поэтому это единственный корневой модуль Terraform, который CI применяет напрямую. После этого все остальные модули применяются через комментарии Atlantis в MR.

Порядок запуска job на master pipeline (все - ручные):
1. `seed:atlantis-lockbox` - см. [шаг 2a](#2a-заполнение-atlantis-lockboxes-operator-ip-gitlab-token-webhook-secret).
2. `bringup:platform` - применяет `platform/` и создаёт VM Atlantis. Cloud-init читает `atlantis-app` при загрузке.
3. `bringup:check-atlantis` - запрашивает у YC состояние NLB Atlantis через `getTargetStates`. Первая проверка сразу может завершиться ошибкой, если статус не `HEALTHY`. Если job завершился ошибкой, можно сделать повторный запуск примерно через минуту - cloud-init нужно несколько минут, чтобы загрузить env-файлы из Lockbox при первой загрузке.

   В конце job также выводит текущий `atlantis_webhook_url` - в каждом репозитории, которым управляет Atlantis (пути, совпадающие с `atlantis_repo_allowlist`), нужно перейти в **Project → Settings → Webhooks → `atlantis-webhook`** и вставить URL. Триггеры: **Push events, Comments, Merge request events**. Внешний IP NLB меняется при каждом запуске «с нуля»; secret - нет. **Особенность UI GitLab:** поле secret сбрасывается при сохранении, если в нём ничего не введено, поэтому secret тоже придётся ввести заново. Получить его можно из Lockbox `atlantis-app-env`: `yc lockbox payload get --id "$LOCKBOX_ID" --format json | jq -r '.entries[] | select(.key == "webhook_secret") | .text_value'`.

Повторный запуск `bringup:platform` используется для выкатки нового значения `var.atlantis_version` - Atlantis не может управлять самим собой, поэтому это job - единственный способ обновлять Atlantis.

Если `bringup:check-atlantis` продолжает завершаться ошибкой - более глубокий диагностический скрипт `check_atlantis.sh` подключается по SSH через bastion и проверяет состояние systemd и env-файлы из Lockbox. Bastion появится только на шаге 3a, поэтому до этого момента остаётся YC serial console на VM Atlantis; `check_atlantis.sh` запускается локально после выполнения 3a.

## 3a. Применение `main` через Atlantis

Корневой модуль `main/` (bastion, VM для k8s, ingress NLB) управляется Atlantis. Достаточно открыть любой MR (diff не обязательно должен затрагивать `main/`) и добавить в нём комментарий:

```
atlantis plan -p main
```

`-p` совпадает с именем проекта из [atlantis.yaml](https://gitlab.com/laura.grechenko.erlang-group/infra-pandora-box/-/blob/master/atlantis.yaml). Atlantis публикует plan в виде комментария к MR примерно за 30 секунд. Затем добавляется комментарий `atlantis apply -p main`. Последующие изменения проходят по тому же сценарию; если diff в MR сам включает `main/*.tf` или `*.tfvars` - autoplan срабатывает без явного комментария.

Теперь bastion развёрнут, поэтому доступен более глубокий диагностический скрипт для Atlantis - он запускается локально, если в `bringup:check-atlantis` обнаружились подозрительные сигналы:
```bash
"$REPO_ROOT/infra/scripts/check_atlantis.sh"   # SSH-через-bastion: oneshot active + env-файлы непустые
```

## 3b. Применение инфраструктуры pandora-box через Atlantis

Корневой модуль `pandora-box/` (bucket для backups, ограниченный SA, Lockbox) управляется Atlantis. Статический access-key никогда не попадает в tfstate или в `terraform output` - он записывается напрямую в Lockbox через `output_to_lockbox`, а ESO материализует его как Secret `pandora-box/backups-s3` далее на шаге 8. `eso_sa_id` читается из state bootstrap через [pandora-box/data.tf](https://gitlab.com/laura.grechenko.erlang-group/infra-pandora-box/-/blob/master/infra/terraform/yc/pandora-box/data.tf), поэтому env-скрипт с локальной машины не требуется.

Достаточно открыть любой MR (можно использовать тот же, что и в 3a) и добавить комментарий:

```
atlantis plan -p pandora-box
atlantis apply -p pandora-box
```

Используется тот же шаблон `-p <project-name>`, что и в 3a. Список проектов находится в [atlantis.yaml](https://gitlab.com/laura.grechenko.erlang-group/infra-pandora-box/-/blob/master/atlantis.yaml) в корне репозитория.

## 4. Проверка готовности нод перед установкой k8s

Перед установкой проверяются SSH-доступ, связность между нодами и доступ в интернет с каждой ноды. Kubespray завершится ошибкой на трудно интерпретируемых шагах, если что-то из этого не работает, - обнаружить проблему здесь экономит час времени.

**CI (предпочтительный способ):** запуск ручного job `cluster:check-nodes` на master pipeline. Job получает SSH-ключ из Lockbox bootstrap, запускает тот же скрипт и выводит таблицу PASS/FAIL по каждому хосту. Runner выходит наружу через NAT-пул, размещённый GitLab; доступ к bastion разрешён широким диапазоном `gitlab_runner_cidrs`.

**С локальной машины (резервный вариант / для быстрых итераций):**
```bash
"$REPO_ROOT/infra/scripts/check_nodes.sh"   # SSH + node-to-node ping + node-to-internet (registry.k8s.io)
```

Все проверки должны вывести `OK`. При появлении `FAIL` необходимо устранить корневую причину (security group, NAT gateway, route table, SSH-ключ), прежде чем продолжать.

## 5. Установка Kubernetes через Kubespray

Тяжёлая одноразовая операция на весь срок жизни кластера - занимает примерно 30–60 минут на кластере из 3 master и 2 worker нод. Запускается с локальной машины: для bootstrap self-managed кластера выбран документированный runbook, а не SaaS CI, в основном потому, что отлаживать упавшую play удалённо (нет `--start-at-task`, нет возможности заглянуть в inventory посреди прогона) болезненно, и в итоге всё равно приходится переходить в локальный shell.

**Клонирование Kubespray** в `infra/ansible/kubespray/` (каталог исключён через `.gitignore` - см. [`.gitignore`](https://gitlab.com/laura.grechenko.erlang-group/infra-pandora-box/-/blob/master/.gitignore) - поскольку включение примерно 4000 файлов в репозиторий сильно бы его раздуло). Тег фиксируется явно; этот проект разрабатывался под `v2.30.0`:
```bash
git clone --depth 1 --branch v2.30.0 https://github.com/kubernetes-sigs/kubespray.git \
  "$REPO_ROOT/infra/ansible/kubespray"
```

**Однократная настройка Python/Ansible** (Kubespray фиксирует конкретные версии, поэтому требуется venv):
```bash
cd "$REPO_ROOT/infra/ansible/kubespray"
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

**Инициализация inventory** путём копирования примера Kubespray (`sample`) в `mycluster`. Это даёт значения по умолчанию из `group_vars/` (cluster, etcd, all → kube-vip, network plugin, addons); генератор inventory перезапишет `hosts.yaml` в этом каталоге на следующем шаге:
```bash
cp -rp "$REPO_ROOT/infra/ansible/kubespray/inventory/sample" \
       "$REPO_ROOT/infra/ansible/kubespray/inventory/mycluster"
```

**Генерация inventory и запуск playbook** (если открыт новый shell, venv нужно активировать повторно: `source "$REPO_ROOT/infra/ansible/kubespray/.venv/bin/activate"`). Скрипт записывает в `infra/ansible/kubespray/inventory/mycluster/hosts.yaml` - `OUT` в [`infra/scripts/generate_inventory.sh`](https://gitlab.com/laura.grechenko.erlang-group/infra-pandora-box/-/blob/master/infra/scripts/generate_inventory.sh) корректируется, если выше использовалось другое имя inventory:
```bash
cd "$REPO_ROOT/infra/terraform/yc/main" && terraform init >/dev/null   # подтянуть state в локальный .terraform/
"$REPO_ROOT/infra/scripts/generate_inventory.sh"
cd "$REPO_ROOT/infra/ansible/kubespray"
ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml
```
Inventory использует `ProxyCommand` через публичный IP bastion (читается из outputs Terraform). Локальная машина должна оставаться в сети на всё время выполнения. Пример того, как выглядит сгенерированный `hosts.yaml` (с подставленными IP-заглушками): [`infra/ansible/hosts-example.yaml`](https://gitlab.com/laura.grechenko.erlang-group/infra-pandora-box/-/blob/master/infra/ansible/hosts-example.yaml).

## 6. Получение kubeconfig
```bash
# IPs по умолчанию из terraform outputs; передайте <bastion-ip> <master-private-ip> для override.
"$REPO_ROOT/infra/scripts/fetch_kubeconfig.sh"
export KUBECONFIG=~/.kube/config-pandora
# Скрипт печатает точную команду SSH-туннеля; запустите её, затем:
kubectl get nodes
```

## 7. Установка GitLab agent (включает управление кластером из CI)

Этот шаг выполняется **до** шагов 8–11, если ESO / CSI / Gateway / Monitoring планируется применять через CI (job'ы `addons:*` аутентифицируются через автоматически инжектируемый контекст агента `K8S_AGENT_CONTEXT`). При применении с локальной машины - шаг можно отложить до самого конца. В любом случае он необходим до того, как CI-job `deploy` для pandora-box сможет выполнить `kubectl apply` в кластере - API-сервер остаётся приватным; CI обращается к нему через исходящий туннель агента.

1. В UI gitlab.com: **Operate → Kubernetes clusters → Connect a cluster (agent)**. Кластер именуется `pandora-k8s`. Registration token копируется для следующего шага.
2. В проект GitLab, из которого пойдёт деплой, коммитится `.gitlab/agents/pandora-k8s/config.yaml`:
   ```yaml
   ci_access:
     projects:
       - id: lauragrechenko/pandora_box
   ```
3. Установка agentk в кластере (скрипт запрашивает token и не выводит его в консоль):
   ```bash
   "$REPO_ROOT/infra/scripts/install_gitlab_agent.sh"
   ```
4. Проверка:
   ```bash
   kubectl -n gitlab-agent-pandora-k8s get pods   # под агента в Running
   ```
5. В `.gitlab-ci.yml` проекта, из которого идёт деплой:
   ```yaml
   deploy:
     image: bitnami/kubectl:latest
     script:
       - kubectl config use-context lauragrechenko/pandora_box:pandora-k8s
       - kubectl apply -f k8s/
   ```

## 8. Установка External Secrets Operator (ESO)

ESO непрерывно синхронизирует учётные данные, хранящиеся в Lockbox, с k8s Secrets - больше не требуется выполнять `kubectl create secret` при каждой ротации. Три `ExternalSecret`:

- `kube-system/yc-csi-sa-key` → `sa-key.json` для CSI driver (используется на шаге 9).
- `pandora-box/yc-registry` → image-pull secret типа `dockerconfigjson`. Подключается в pod specs через `imagePullSecrets: [{ name: yc-registry }]`.
- `pandora-box/backups-s3` → имя bucket и HMAC-пара (`BACKUPS_S3_*`) для backup-writer приложения PandoraBox. Pod подключает через `envFrom: { secretRef: { name: backups-s3 } }`.

ESO требует один императивный seed (`external-secrets/yc-lockbox-sa-key` - Secret с authorized-key) - provider ESO для YC Lockbox поддерживает только аутентификацию через authorized-key. На этапе bootstrap соответствующие приватные ключи сохраняются в записях Lockbox по одному на потребителя: см. [terraform/yc/bootstrap/storage_csi.tf](https://gitlab.com/laura.grechenko.erlang-group/infra-pandora-box/-/blob/master/infra/terraform/yc/bootstrap/storage_csi.tf), [registry.tf](https://gitlab.com/laura.grechenko.erlang-group/infra-pandora-box/-/blob/master/infra/terraform/yc/bootstrap/registry.tf).

**Запуск job на master pipeline** (предпочтительный способ - аутентификация через kubeconfig от GitLab Agent из [шага 7](#7-установка-gitlab-agent-включает-управление-кластером-из-ci)): `addons:eso` - выполняет [`install_eso.sh`](https://gitlab.com/laura.grechenko.erlang-group/infra-pandora-box/-/blob/master/infra/scripts/install_eso.sh).

**Проверка** (с локальной машины, `KUBECONFIG` из шага 6):
```bash
kubectl -n external-secrets get pods                                   # ESO controller в Running
kubectl get externalsecret -A                                          # 3 ExternalSecrets, статус SecretSynced
```

**Ручной запуск** (только если CI недоступен):
```bash
"$REPO_ROOT/infra/scripts/install_eso.sh"
```

## 9. Установка YC Disk CSI driver и StorageClass

YC Disk CSI driver позволяет PVC динамически создавать настоящие YC Compute Disks (данные переживают рестарты pod и node - диск переподключается туда, где запустился pod). Манифесты из `yandex-cloud/yc-csi-driver` `deploy/v1.2.0/` включены в репозиторий ([k8s/csi/v1.2.0/](https://gitlab.com/laura.grechenko.erlang-group/infra-pandora-box/-/tree/master/infra/k8s/csi/v1.2.0)), а также ConfigMap `yc-csi-config`, указывающий целевой каталог (folder) YC.

**Запускается после шага 8** - pod'ы CSI driver используют Secret `kube-system/yc-csi-sa-key`, который материализуется ESO; запуск CSI до ESO приведёт к тому, что pod'ы зависнут в `CrashLoopBackOff`.

**Запуск job на master pipeline** (предпочтительный способ): `addons:csi` - применяет манифесты из репозитория и создаёт `yc-csi-config`.

**Проверка** (с локальной машины, `KUBECONFIG` из шага 6):
```bash
kubectl -n kube-system get pods -l 'app in (yc-csi-controller,yc-csi-node)'   # controller + node поды в Running
kubectl get storageclass                                                       # yc-network-hdd помечен (default)
```

**Ручной запуск** (только если CI недоступен):
```bash
kubectl -n kube-system create configmap yc-csi-config \
  --from-literal=folderId="$(terraform -chdir="$REPO_ROOT/infra/terraform/yc/bootstrap" output -raw folder_id)" \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f "$REPO_ROOT/infra/k8s/csi/v1.2.0/"
```

## 10. Установка Envoy Gateway

NLB (создаётся `terraform apply` на шаге 3) принимает трафик на :80 и перенаправляет его на NodePort 30080 (data-plane Envoy) на worker-нодах. NodePort должен совпадать с `var.ingress_nodeport`. Workloads публикуют HTTP-эндпойнты через `HTTPRoute`, привязанные к общекластерному Gateway `public`.

Устанавливает контроллер Envoy Gateway ([k8s/gateway/values.yaml](https://gitlab.com/laura.grechenko.erlang-group/infra-pandora-box/-/blob/master/infra/k8s/gateway/values.yaml)) и применяет `GatewayClass` и `Gateway` ([k8s/gateway/gateway-class.yaml](https://gitlab.com/laura.grechenko.erlang-group/infra-pandora-box/-/blob/master/infra/k8s/gateway/gateway-class.yaml), [k8s/gateway/gateway.yaml](https://gitlab.com/laura.grechenko.erlang-group/infra-pandora-box/-/blob/master/infra/k8s/gateway/gateway.yaml)).

**Запуск job на master pipeline** (предпочтительный способ - аутентификация через kubeconfig от GitLab Agent из [шага 7](#7-установка-gitlab-agent-включает-управление-кластером-из-ci)): `addons:gateway` - выполняет [`install_gateway.sh`](https://gitlab.com/laura.grechenko.erlang-group/infra-pandora-box/-/blob/master/infra/scripts/install_gateway.sh).

**Проверка** (с локальной машины, `KUBECONFIG` из шага 6):
```bash
kubectl -n envoy-gateway-system get pods                # controller в Running
kubectl get gatewayclass,gateway -A                     # public Gateway PROGRAMMED=True
```

**Ручной запуск** (только если CI недоступен):
```bash
"$REPO_ROOT/infra/scripts/install_gateway.sh"
```

## 11. Развёртывание мониторинга (kube-prometheus-stack)

Values хранятся в [k8s/monitoring/values.yaml](https://gitlab.com/laura.grechenko.erlang-group/infra-pandora-box/-/blob/master/infra/k8s/monitoring/values.yaml); HTTPRoute (привязан к Gateway `public` из шага 10) - в [k8s/monitoring/grafana-httproute.yaml](https://gitlab.com/laura.grechenko.erlang-group/infra-pandora-box/-/blob/master/infra/k8s/monitoring/grafana-httproute.yaml). Сбор метрик с controller-manager, scheduler, etcd и kube-proxy отключён (Kubespray привязывает их к localhost).

**Запуск job на master pipeline** (предпочтительный способ): `addons:monitoring` - выполняет [`install_monitoring.sh`](https://gitlab.com/laura.grechenko.erlang-group/infra-pandora-box/-/blob/master/infra/scripts/install_monitoring.sh).

**Проверка** (с локальной машины, `KUBECONFIG` из шага 6):
```bash
kubectl -n monitoring get pods                          # prometheus / grafana / alertmanager в Running
echo "http://$(terraform -chdir="$REPO_ROOT/infra/terraform/yc/main" output -raw ingress_lb_ip)/grafana/"   # Grafana, по умолчанию admin/admin
```

**Ручной запуск** (только если CI недоступен):
```bash
"$REPO_ROOT/infra/scripts/install_monitoring.sh"
```

## Manual escape-hatch: когда `export_s3_tfstate_env.sh` не может прочитать state

Скрипт вызывает `terraform output` для bootstrap, чтобы извлечь ключи S3-бэкенда, - но state самого bootstrap лежит в том же S3-bucket, поэтому без рабочих `AWS_*` в shell прочитать его нечем. Когда Atlantis уже развёрнут - это не проблема: Atlantis выполняет все plan/apply со своим ключом, полученным из Lockbox. Проблема курицы и яйца возникает только в чистом shell без `~/.aws/credentials` (например, при самом первом bootstrap или на новой машине).

Способ восстановления - создать временный внеплановый статический ключ для terraform SA, прочитать с его помощью state, затем удалить:

```bash
yc iam access-key create \
  --service-account-name pandora-box-dev-terraform-sa \
  --format json > /tmp/yctf.json

export AWS_ACCESS_KEY_ID=$(jq -r .access_key.key_id /tmp/yctf.json)
export AWS_SECRET_ACCESS_KEY=$(jq -r .secret /tmp/yctf.json)

source "$REPO_ROOT/infra/scripts/export_s3_tfstate_env.sh"   # перезапишет AWS_* in-state значениями

yc iam access-key delete "$(jq -r .access_key.id /tmp/yctf.json)"
rm /tmp/yctf.json
```

## Recovery: `bootstrap-from-scratch.sh` упал на полпути в `terraform apply`

Если `terraform apply` внутри скрипта завершается ошибкой (например, `AlreadyExists` для service account, оставшегося от неполного предыдущего destroy) - скрипт завершает работу, его trap восстанавливает `backend.tf`, но `terraform.tfstate` теперь содержит **частично применённые** ресурсы, а `.terraform/` сконфигурирован для local backend. Последующие команды завершаются ошибкой:

```
Error: Backend initialization required, please run "terraform init"
Reason: Initial configuration of the requested backend "s3"
```

…потому что `backend.tf` (s3) и `.terraform/` (local) рассинхронизированы. Встроенная защита от повторного запуска в скрипте отказывается начинать заново при непустом `terraform.tfstate` - это защищает от случайного удаления частичного state.

**Решение вручную** - выполнить destroy частично применённого ресурса локально, затем начать с чистого листа:

```bash
cd "$REPO_ROOT/infra/terraform/yc/bootstrap"

# Снова отключить s3, чтобы говорить с локальным state
mv backend.tf backend.tf.disabled

# Сбросить .terraform/, но СОХРАНИТЬ terraform.tfstate - там частичный apply
rm -rf .terraform
terraform init

# Уничтожить то, что было частично создано
terraform destroy

# Чистое состояние
rm -f terraform.tfstate terraform.tfstate.backup
mv backend.tf.disabled backend.tf
```

Затем **YC сканируется на наличие orphan-ресурсов** - как тот ресурс, который изначально привёл к ошибке apply, так и всё прочее, что не находится ни в одном state-файле. На этапе bootstrap создаются ресурсы в нескольких сервисах:

```bash
yc iam service-account list                    --folder-id "$YC_FOLDER_ID"
yc storage bucket list                         --folder-id "$YC_FOLDER_ID"
yc lockbox secret list                         --folder-id "$YC_FOLDER_ID"
yc kms symmetric-key list                      --folder-id "$YC_FOLDER_ID"
yc container registry list                     --folder-id "$YC_FOLDER_ID"
yc iam workload-identity oidc-federation list  --folder-id "$YC_FOLDER_ID"
```

Все остатки с именами в стиле bootstrap (например, `pandora-box-dev-*`) удаляются. Затем выполняется повторный запуск:

```bash
export YC_TOKEN=$(yc iam create-token)
"$REPO_ROOT/infra/scripts/bootstrap-from-scratch.sh"
```

> Скрипт очищает устаревшие `AWS_*` из shell перед локальным apply - иначе старые ключи из direnv приведут к ошибке `403 AccessDenied` при создании `yandex_storage_bucket`. После того как скрипт запишет новые ключи, direnv требуется перезагрузить.

## Очистка

Destroy выполняется в порядке, обратном зависимостям, - все корневые модули, кроме `bootstrap`, хранят свой state в bucket, созданном на этапе `bootstrap`, поэтому `bootstrap` уничтожается **последним**. `main` в обычной работе управляется Atlantis, но для teardown destroy выполняется локально с учётными данными bootstrap (`AWS_*` из direnv и `YC_TOKEN` из `yc iam create-token`) - Atlantis всё равно вскоре будет уничтожен вместе с `platform`.

```bash
export YC_TOKEN=$(yc iam create-token)        # yandex provider
# AWS_* должны уже быть в env через direnv (.envrc.local)

cd "$REPO_ROOT/infra/terraform/yc/pandora-box" && terraform destroy
cd "$REPO_ROOT/infra/terraform/yc/main"        && terraform destroy
cd "$REPO_ROOT/infra/terraform/yc/platform"    && terraform destroy
```

`bootstrap/` - особый случай: его state хранится в bucket, который он сейчас удалит, поэтому state сначала мигрируется обратно в local:

```bash
cd "$REPO_ROOT/infra/terraform/yc/bootstrap"
mv backend.tf backend.tf.disabled
terraform init -migrate-state -force-copy
```

На state-bucket установлены `lifecycle.prevent_destroy = true` и включённый versioning, поэтому обычный `terraform destroy` завершается ошибкой:

```
Resource yandex_storage_bucket.tfstate has lifecycle.prevent_destroy set, but the
plan calls for this resource to be destroyed.
```

**Шаблон edit → apply → destroy → revert (правки в bucket.tf не коммитятся):**

1. В `bucket.tf` временно отключаются оба механизма защиты на ресурсе `yandex_storage_bucket.tfstate`:
   - `prevent_destroy = true` → `prevent_destroy = false` внутри блока `lifecycle {}` **и**
   - добавляется `force_destroy = true` на ресурс (versioned bucket не удаляются без этого флага).
2. **Сначала выполняется apply**, чтобы `force_destroy = true` зафиксировался в state ресурса, - иначе destroy может попасть в гонку между удалением bucket и неудалёнными версиями объектов:

   ```bash
   terraform apply
   ```

3. Затем выполняется destroy и очистка локального state:

   ```bash
   terraform destroy
   rm -f terraform.tfstate terraform.tfstate.backup
   mv backend.tf.disabled backend.tf            # восстановить для следующего from-scratch run
   ```

4. Обе правки в `bucket.tf` **откатываются** (`git checkout -- bucket.tf`). Не следует коммитить `force_destroy = true` или ослабленный `prevent_destroy` - эти защиты существуют именно для того, чтобы случайный `terraform apply` будущего оператора не уничтожил state-bucket.
