resource "yandex_vpc_network" "this" {
  name        = var.vpc_name
  description = var.env_name != null ? "VPC for ${var.env_name} environment" : "Default VPC"
}

resource "yandex_vpc_subnet" "this" {
  count = length(var.subnets)

  name           = var.env_name != null ? "${var.env_name}-${var.vpc_name}-subnet-${var.subnets[count.index].zone}" : "${var.vpc_name}-subnet-${var.subnets[count.index].zone}"
  zone           = var.subnets[count.index].zone
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = var.subnets[count.index].cidr
  description    = var.env_name != null ? "Subnet for ${var.env_name} environment" : "Default subnet"
}