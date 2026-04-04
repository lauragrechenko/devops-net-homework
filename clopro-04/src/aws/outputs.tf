output "rds_endpoint" {
  value       = aws_db_instance.mysql.endpoint
  description = "RDS primary instance endpoint"
}

output "phpmyadmin_url" {
  value       = "http://${kubernetes_service_v1.phpmyadmin_lb.status[0].load_balancer[0].ingress[0].hostname}"
  description = "phpMyAdmin URL via ELB"
}