resource "yandex_vpc_network" "this" {
  name = "${local.name_prefix}-vpc"
}

resource "yandex_vpc_subnet" "public" {
  name           = "${local.name_prefix}-subnet-public"
  v4_cidr_blocks = var.cidr_public
  zone           = var.default_zone
  network_id     = yandex_vpc_network.this.id
}

resource "yandex_vpc_subnet" "private" {
  name           = "${local.name_prefix}-subnet-private"
  v4_cidr_blocks = var.cidr_private
  zone           = var.default_zone
  network_id     = yandex_vpc_network.this.id
  route_table_id = yandex_vpc_route_table.nat_route.id
}

resource "yandex_vpc_route_table" "nat_route" {
  name       = "${local.name_prefix}-nat-route"
  network_id = yandex_vpc_network.this.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = var.vm_nat_ip_address
  }
}

resource "yandex_compute_instance" "nat_instance" {
  name        = "${local.name_prefix}-nat-vm"
  platform_id = var.vm_nat_platform_id
  zone        = var.default_zone

  resources {
    cores         = var.vm_nat_cores
    memory        = var.vm_nat_memory
    core_fraction = var.vm_nat_core_fraction
  }

  scheduling_policy {
    preemptible = var.vm_nat_preemptible
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_nat_image_id
      size     = var.vm_nat_disk_size
      type     = var.vm_nat_disk_type
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.public.id
    nat        = var.vm_nat_enable_nat
    ip_address = var.vm_nat_ip_address
  }
}

resource "yandex_compute_instance" "public_test_vm" {
  name        = "${local.name_prefix}-public-vm"
  platform_id = var.vm_public_platform_id
  zone        = var.default_zone

  resources {
    cores         = var.vm_public_cores
    memory        = var.vm_public_memory
    core_fraction = var.vm_public_core_fraction
  }

  scheduling_policy {
    preemptible = var.vm_public_preemptible
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_public_image_id
      size     = var.vm_public_disk_size
      type     = var.vm_public_disk_type
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = var.vm_public_enable_nat
  }

  metadata = {
    ssh-keys = "${var.ssh_user_name}:${local.ssh_pub_key}"
  }
}

resource "yandex_compute_instance" "private_test_vm" {
  name        = "${local.name_prefix}-private-vm"
  platform_id = var.vm_private_platform_id
  zone        = var.default_zone

  resources {
    cores         = var.vm_private_cores
    memory        = var.vm_private_memory
    core_fraction = var.vm_private_core_fraction
  }

  scheduling_policy {
    preemptible = var.vm_private_preemptible
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_private_image_id
      size     = var.vm_private_disk_size
      type     = var.vm_private_disk_type
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    nat       = var.vm_private_enable_nat
  }

  metadata = {
    ssh-keys = "${var.ssh_user_name}:${local.ssh_pub_key}"
  }
}