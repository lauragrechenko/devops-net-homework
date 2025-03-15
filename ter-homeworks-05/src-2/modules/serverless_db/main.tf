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
    "${var.iam_member_prefix}:${var.iam_service_account_id}"
  ]
}