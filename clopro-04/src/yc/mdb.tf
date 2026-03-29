resource "yandex_mdb_mysql_cluster" "mysql_cluster" {
  name        = "${local.name_prefix}-mysql-cluster"
  environment = local.env_to_mdb[var.env]
  network_id  = yandex_vpc_network.this.id
  version     = var.cluster_version

  deletion_protection = var.deletion_protection

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

  backup_window_start {
    hours   = var.backup_window_start.hours
    minutes = var.backup_window_start.minutes
  }

  maintenance_window {
    type = var.maintenance_window_type
  }
}

resource "yandex_mdb_mysql_database" "netology_db" {
  cluster_id = yandex_mdb_mysql_cluster.mysql_cluster.id
  name       = var.db_name
}

resource "yandex_mdb_mysql_user" "netology_user" {
  cluster_id = yandex_mdb_mysql_cluster.mysql_cluster.id

  permission {
    database_name = yandex_mdb_mysql_database.netology_db.name
    roles         = var.db_user_permissions
  }

  name                  = var.db_user_name
  password              = var.db_user_password
  authentication_plugin = var.db_authentication_plugin
}