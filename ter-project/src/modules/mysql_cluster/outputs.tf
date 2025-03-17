output "cluster_id" {
  value       = yandex_mdb_mysql_cluster.this.id
  description = "ID of the managed MySQL cluster."
}