terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "~>1.10.5"
}

locals {
  cluster_hosts = var.ha ? var.host_configs : [var.host_configs[0]]
}

resource "yandex_mdb_mysql_cluster" "this" {
  name        = var.cluster_name
  description = "MySQL cluster for ${var.env_name} environment"
  
  environment = var.env_name
  network_id  = var.network_id
  version     = var.cluster_version

  resources {
    resource_preset_id = var.resources_preset_id
    disk_type_id       = var.resources_disk_type_id
    disk_size          = var.resources_disk_size
  }

  dynamic "host" {
    for_each = local.cluster_hosts

    content {
      zone      = host.value.zone
      subnet_id = host.value.subnet_id
    }
  }
}