output "vm_instances_info" {
  description = "Instance name, public ip for each VM"
  value = [
    for instance in yandex_compute_instance.this : {
      name = instance.name
      ip   = instance.network_interface[0].nat_ip_address
    }
  ]
}