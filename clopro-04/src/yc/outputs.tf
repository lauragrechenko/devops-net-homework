output "phpmyadmin_url" {
  value = "http://${kubernetes_service_v1.phpmyadmin_lb.status[0].load_balancer[0].ingress[0].ip}"
}

output "mysql_host" {
  value = yandex_mdb_mysql_cluster.mysql_cluster.host[0].fqdn
}
