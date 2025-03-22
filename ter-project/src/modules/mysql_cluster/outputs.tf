output "cluster_id" {
  value       = yandex_mdb_mysql_cluster.this.id
  description = "ID of the managed MySQL cluster."
}

output "db_host_fqdns" {
  value = [for host in yandex_mdb_mysql_cluster.this.host : host.fqdn]
}