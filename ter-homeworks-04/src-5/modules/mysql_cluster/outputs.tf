output "cluster_id" {
  value       = yandex_mdb_mysql_cluster.this.id
  description = "ID of the managed MySQL cluster."
}

output "cluster_description" {
  value       = yandex_mdb_mysql_cluster.this.description
  description = "Description of the managed MySQL cluster."
}