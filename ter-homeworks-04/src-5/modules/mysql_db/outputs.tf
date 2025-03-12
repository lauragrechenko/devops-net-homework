output "database_id" {
  value       = yandex_mdb_mysql_database.this.id
  description = "ID of the created MySQL database."
}

output "user_id" {
  value       = yandex_mdb_mysql_user.this.id
  description = "ID of the created MySQL user."
}