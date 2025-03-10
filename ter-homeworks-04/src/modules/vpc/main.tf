resource "yandex_vpc_network" "this" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "this" {
  name           = "${var.vpc_name}-subnet-${var.subnet_zone}"
  zone           = var.subnet_zone
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = var.subnet_cidr
}