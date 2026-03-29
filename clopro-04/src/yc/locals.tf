locals {
  name_prefix = "${var.project}-${var.env}"

  env_to_mdb = {
    dev   = "PRESTABLE"
    stage = "PRESTABLE"
    prod  = "PRODUCTION"
  }

  host_configs = [
    {
      zone      = var.default_zone
      subnet_id = yandex_vpc_subnet.private_a.id
    },
    {
      zone      = var.zone_secondary
      subnet_id = yandex_vpc_subnet.private_b.id
    }
  ]

  cluster_hosts = var.ha ? local.host_configs : [local.host_configs[0]]
}