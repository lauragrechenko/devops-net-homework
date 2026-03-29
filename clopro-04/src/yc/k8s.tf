resource "yandex_kubernetes_cluster" "regional_cluster" {
  name        = "${local.name_prefix}-k8s-cluster"
  description = "Managed Kubernetes regional cluster for ${var.project} ${var.env}"

  network_id = yandex_vpc_network.this.id

  master {
    regional {
      region = var.k8s_cluster_region

      location {
        zone      = yandex_vpc_subnet.public_primary.zone
        subnet_id = yandex_vpc_subnet.public_primary.id
      }

      location {
        zone      = yandex_vpc_subnet.public_secondary.zone
        subnet_id = yandex_vpc_subnet.public_secondary.id
      }

      location {
        zone      = yandex_vpc_subnet.public_tertiary.zone
        subnet_id = yandex_vpc_subnet.public_tertiary.id
      }
    }

    version   = var.k8s_version
    public_ip = var.k8s_master_public_ip
  }

  service_account_id      = yandex_iam_service_account.k8s_cluster.id
  node_service_account_id = yandex_iam_service_account.k8s_node.id

  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s_cluster_agent,
    yandex_resourcemanager_folder_iam_member.vpc_public_admin,
  ]

  labels = {
    env = var.env
  }

  kms_provider {
    key_id = yandex_kms_symmetric_key.k8s_kms_key.id
  }
}

resource "yandex_kms_symmetric_key" "k8s_kms_key" {
  name              = "${local.name_prefix}-k8s-key"
  default_algorithm = var.kms_key_algorithm
  rotation_period   = var.kms_key_rotation_period
}

resource "yandex_kubernetes_node_group" "my_node_group" {
  cluster_id  = yandex_kubernetes_cluster.regional_cluster.id
  name        = "${local.name_prefix}-k8s-node-group"
  description = "description"
  version     = var.k8s_version

  labels = {
    env = var.env
  }

  instance_template {
    platform_id = var.k8s_node_platform_id

    network_interface {
      nat = var.k8s_node_nat
      subnet_ids = [
        yandex_vpc_subnet.private_a.id,
      ]
    }

    resources {
      memory = var.k8s_node_memory
      cores  = var.k8s_node_cores
    }

    boot_disk {
      type = var.k8s_node_disk_type
      size = var.k8s_node_disk_size
    }

    scheduling_policy {
      preemptible = var.k8s_node_preemptible
    }

    container_runtime {
      type = var.k8s_node_container_runtime
    }
  }

  scale_policy {
    auto_scale {
      initial = var.k8s_node_scale_initial
      min     = var.k8s_node_scale_min
      max     = var.k8s_node_scale_max
    }
  }

  allocation_policy {
    location {
      zone = var.default_zone
    }
  }
}