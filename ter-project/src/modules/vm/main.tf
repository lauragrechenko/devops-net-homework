terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.8.4"
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_image_family
}

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
    subnet_id = var.vpc_subnet_id
    nat       = var.vm_web_nat_enabled
    security_group_ids = var.security_group_ids
  }

  metadata = {
    serial-port-enable = var.vm_web_serial_port_enabled
    ssh-keys           = "${var.vms_ssh_user}:${var.ssh_pub_key}"
  }
}