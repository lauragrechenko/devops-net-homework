output "network_id" {
  value       = yandex_vpc_network.this.id
  description = "The ID of the created VPC network."
}

output "subnet_id" {
  value       = yandex_vpc_subnet.this.id
  description = "The ID for the created subnet."
}