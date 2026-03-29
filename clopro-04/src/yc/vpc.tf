resource "yandex_vpc_network" "this" {
  name = "${local.name_prefix}-vpc"
}

resource "yandex_vpc_subnet" "public_primary" {
  name           = "${local.name_prefix}-subnet-public-primary"
  v4_cidr_blocks = var.cidr_public
  zone           = var.default_zone
  network_id     = yandex_vpc_network.this.id
}

resource "yandex_vpc_subnet" "public_secondary" {
  name           = "${local.name_prefix}-subnet-public-secondary"
  v4_cidr_blocks = var.cidr_public_secondary
  zone           = var.zone_secondary
  network_id     = yandex_vpc_network.this.id
}

resource "yandex_vpc_subnet" "public_tertiary" {
  name           = "${local.name_prefix}-subnet-public-tertiary"
  v4_cidr_blocks = var.cidr_public_tertiary
  zone           = var.zone_tertiary
  network_id     = yandex_vpc_network.this.id
}

resource "yandex_vpc_subnet" "private_a" {
  name           = "${local.name_prefix}-subnet-private-db-a"
  v4_cidr_blocks = var.cidr_private_a
  zone           = var.default_zone
  network_id     = yandex_vpc_network.this.id
}

resource "yandex_vpc_subnet" "private_b" {
  name           = "${local.name_prefix}-subnet-private-db-b"
  v4_cidr_blocks = var.cidr_private_b
  zone           = var.zone_secondary
  network_id     = yandex_vpc_network.this.id
}

