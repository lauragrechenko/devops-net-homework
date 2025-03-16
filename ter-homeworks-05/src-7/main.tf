### Настройте отдельный terraform root модуль, 
# который будет создавать YDB, s3 bucket для tfstate и сервисный аккаунт с необходимыми правами.

### S3 BUCKET

resource "random_string" "unique_id" {
  length  = var.random_string_length
  upper   = var.random_string_upper
  lower   = var.random_string_lower
  numeric = var.random_string_numeric
  special = var.random_string_special
}

module "s3" {
  source = "git::https://github.com/terraform-yc-modules/terraform-yc-s3.git"

  bucket_name = "${var.s3_bucket_name_prefix}-${random_string.unique_id.result}"
  max_size    = var.s3_bucket_max_size
  versioning = {
    enabled = var.s3_bucket_versioning_enabled
  }
}



### SERVICE ACCOUNT

resource "yandex_iam_service_account" "sa" {
  name        = var.sa_name
  description = var.sa_description
  folder_id   = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "storage-account-iam" {
  folder_id = var.folder_id
  role      = var.storage_iam_member_role
  member    = "var.iam_member_prefix:${yandex_iam_service_account.sa.id}"
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = var.sa_static_key_description
}



### DATABASE

resource "yandex_ydb_database_serverless" "tfstate_ydb" {
  name                = var.tfstate_ydb_name
  deletion_protection = var.tfstate_ydb_deletion_protection

  serverless_database {
    enable_throttling_rcu_limit = var.tfstate_ydb_enable_throttling_rcu_limit
    provisioned_rcu_limit       = var.tfstate_ydb_provisioned_rcu_limit
    storage_size_limit          = var.tfstate_ydb_storage_size_limit
    throttling_rcu_limit        = var.tfstate_ydb_throttling_rcu_limit
  }
}

resource "yandex_ydb_database_iam_binding" "tfstate_ydb_iam_binding" {
  database_id = yandex_ydb_database_serverless.tfstate_ydb.id
  role        = var.tfstate_ydb_role

  members = [
    "${var.iam_member_prefix}:${yandex_iam_service_account.sa.id}"
  ]
}