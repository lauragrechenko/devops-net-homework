resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
  route_table_id = yandex_vpc_route_table.rt.id
}

resource "yandex_vpc_subnet" "db" {
  name           = "${var.vpc_name}-db"
  zone           = var.zone_b
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.db_subnet_cidr
  route_table_id = yandex_vpc_route_table.rt.id
}

resource "yandex_vpc_gateway" "nat_gateway" {
  folder_id = var.folder_id
  name      = var.vpc_gateway_name
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "rt" {
  folder_id  = var.folder_id
  name       = var.vpc_route_table_name
  network_id = yandex_vpc_network.develop.id

  static_route {
    destination_prefix = var.vpc_route_table_destination_prefix
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_image_family
}

resource "yandex_compute_instance" "platform" {
  name        = local.vm_web_instance_name
  platform_id = var.vm_web_platform_id

  resources {
    cores         = var.vms_resources["web"].cores
    memory        = var.vms_resources["web"].memory_gb
    core_fraction = var.vms_resources["web"].core_fraction
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
  }

  metadata = var.metadata
}

resource "yandex_compute_instance" "platform_db" {
  name        = local.vm_db_instance_name
  platform_id = var.vm_db_platform_id
  zone        = var.zone_b

  resources {
    cores         = var.vms_resources["db"].cores
    memory        = var.vms_resources["db"].memory_gb
    core_fraction = var.vms_resources["db"].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible = var.vm_db_preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.db.id
    nat       = var.vm_db_nat_enabled
  }

  metadata = var.metadata
}