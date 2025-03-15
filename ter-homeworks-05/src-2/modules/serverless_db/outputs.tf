output "tfstate_ydb_id" {
  value       = yandex_ydb_database_serverless.tfstate_ydb.id
  description = "ID of the Yandex YDB serverless database."
}

output "tfstate_ydb_full_endpoint" {
  value       = yandex_ydb_database_serverless.tfstate_ydb.ydb_full_endpoint
  description = "Full endpoint of the Yandex YDB serverless database."
}

output "tfstate_ydb_document_api_endpoint" {
  value       = yandex_ydb_database_serverless.tfstate_ydb.document_api_endpoint
  description = "Document API endpoint of the Yandex Database serverless cluster."
}

output "tfstate_ydb_database_path" {
  value       = yandex_ydb_database_serverless.tfstate_ydb.ydb_full_endpoint
  description = "Full database path of the Yandex Database serverless cluster."
}