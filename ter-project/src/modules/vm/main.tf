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

resource "yandex_compute_instance" "this" {
  count = var.vm_count

  name        = "${var.vm_name_prefix}-${count.index + 1}"
  platform_id = var.vm_platform_id

  resources {
    cores         = var.vm_cores
    memory        = var.vm_memory_gb
    core_fraction = var.vm_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible = var.vm_preemptible
  }

  network_interface {
    subnet_id          = var.vpc_subnet_id
    nat                = var.vm_nat_enabled
    security_group_ids = var.security_group_ids
  }

  metadata = var.vm_metadata

  service_account_id = var.service_account_id
}

resource "yandex_container_registry_iam_binding" "puller" {
  registry_id = var.container_registry_id
  role        = var.registry_puller_role

  members = [
    "${var.iam_member_prefix}:${var.service_account_id}"
  ]
}