resource "yandex_compute_instance" "web" {
  count = var.vm_web_count

  name        = "${var.vm_web_name_prefix}-${count.index + 1}"
  platform_id = var.vm_web_platform_id

  resources {
    cores         = var.vm_web_cores
    memory        = var.vm_web_memory_gb
    core_fraction = var.vm_web_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_web_nat_enabled
    security_group_ids = [
      yandex_vpc_security_group.example.id
    ]
  }

  metadata = {
    serial-port-enable = var.vm_web_serial_port_enabled
    ssh-keys           = "${var.vms_ssh_user}:${local.ssh_pub_key}"
  }

  depends_on = [
    yandex_compute_instance.db
  ]
}