output "vpc_security_group_id" {
  description = "Id of the security group."
  value       = yandex_vpc_security_group.this.id
}

