locals {
  vpc_full_name = "${var.vpc_name}-${var.vpc_env}"
  ssh_key       = file(var.vms_ssh_root_key)
}

# VPC network
resource "yandex_vpc_network" "k8s" {
  name = local.vpc_full_name
}

# Single subnet in default_zone
resource "yandex_vpc_subnet" "k8s" {
  name           = "${local.vpc_full_name}-${var.default_zone}"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.k8s.id
  v4_cidr_blocks = [var.vpc_subnet_cidr]
}

# Master node(s)
resource "yandex_compute_instance" "master" {
  count       = var.master_count
  name        = "k8s-master-${count.index + 1}"
  platform_id = var.vm_platform_id

  resources {
    cores         = var.master_cores
    memory        = var.master_memory_gb
    core_fraction = var.vm_cpu_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_image_id
      size     = var.master_disk_size_gb
    }
  }


  network_interface {
    subnet_id = yandex_vpc_subnet.k8s.id
    nat       = true
  }

  scheduling_policy {
    preemptible = var.vm_preemptible
  }

  metadata = {
    ssh-keys = "${var.vms_ssh_user}:${local.ssh_key}"
  }
}

# Worker nodes
resource "yandex_compute_instance" "workers" {
  count       = var.worker_count
  name        = "k8s-worker-${count.index + 1}"
  platform_id = var.vm_platform_id

  resources {
    cores         = var.worker_cores
    memory        = var.worker_memory_gb
    core_fraction = var.vm_cpu_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_image_id
      size     = var.worker_disk_size_gb
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.k8s.id
    nat       = true
  }

  scheduling_policy {
    preemptible = var.vm_preemptible
  }

  metadata = {
    ssh-keys = "${var.vms_ssh_user}:${local.ssh_key}"
  }
}

output "master_ips" {
  value = {
    external = [for m in yandex_compute_instance.master : m.network_interface[0].nat_ip_address]
    internal = [for m in yandex_compute_instance.master : m.network_interface[0].ip_address]
  }
}

output "worker_ips" {
  value = {
    external = [for w in yandex_compute_instance.workers : w.network_interface[0].nat_ip_address]
    internal = [for w in yandex_compute_instance.workers : w.network_interface[0].ip_address]
  }
}
