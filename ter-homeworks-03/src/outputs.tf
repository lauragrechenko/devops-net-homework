output "vm_instances_info" {
  description = "Instance name, id and FQDN for each VM"
  value = [
    for instance in concat(
      yandex_compute_instance.web,
      values(yandex_compute_instance.db),
      [yandex_compute_instance.storage]
      ) : {
      name = instance.name
      id   = instance.id
      fqdn = instance.fqdn
    }
  ]
}