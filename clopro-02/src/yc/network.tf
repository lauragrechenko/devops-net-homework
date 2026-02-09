resource "yandex_vpc_network" "this" {
  name = "${local.name_prefix}-vpc"
}

resource "yandex_vpc_subnet" "public" {
  name           = "${local.name_prefix}-subnet-public"
  v4_cidr_blocks = var.cidr_public
  zone           = var.default_zone
  network_id     = yandex_vpc_network.this.id
}