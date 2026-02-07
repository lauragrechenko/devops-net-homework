output "public_vm_ip" {
  description = "Public IP address of the test VM"
  value       = yandex_compute_instance.public_test_vm.network_interface[0].nat_ip_address
}

output "nat_instance_ip" {
  description = "Public IP address of the NAT instance"
  value       = yandex_compute_instance.nat_instance.network_interface[0].nat_ip_address
}

output "nat_instance_internal_ip" {
  description = "Internal IP address of the NAT instance"
  value       = yandex_compute_instance.nat_instance.network_interface[0].ip_address
}

output "private_vm_ip" {
  description = "Internal IP address of the private test VM"
  value       = yandex_compute_instance.private_test_vm.network_interface[0].ip_address
}
