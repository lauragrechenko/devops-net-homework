resource "yandex_compute_disk" "vm_disk" {
  count = var.vm_disk_count
  name  = "${var.vm_disk_name_prefix}-${count.index}"
  size  = var.vm_disk_size
  zone  = var.default_zone
}

resource "yandex_compute_instance" "storage" {
  name        = var.vm_storage_name
  platform_id = var.vm_storage_platform_id

  resources {
    cores         = var.vm_storage_cores
    memory        = var.vm_storage_memory_gb
    core_fraction = var.vm_storage_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  dynamic "secondary_disk" {
    for_each = { for index, disk in yandex_compute_disk.vm_disk : index => disk }

    content {
      disk_id = secondary_disk.value.id
    }
  }

  scheduling_policy {
    preemptible = var.vm_storage_preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_storage_nat_enabled
  }

  metadata = {
    serial-port-enable = var.vm_storage_serial_port_enabled
    ssh-keys           = "${var.vms_ssh_user}:${local.ssh_pub_key}"
  }
}