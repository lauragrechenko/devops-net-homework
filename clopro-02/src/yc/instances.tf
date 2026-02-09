resource "yandex_iam_service_account" "ig_account" {
  name = "${local.name_prefix}-ig-sa"
}

resource "yandex_resourcemanager_folder_iam_member" "ig_editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.ig_account.id}"
}


resource "yandex_compute_instance_group" "vms_ig" {
  name               = "${local.name_prefix}-pb-vms-group"
  folder_id          = var.folder_id
  service_account_id = yandex_iam_service_account.ig_account.id

  instance_template {
    platform_id = var.vms_group_platform_id
    resources {
      memory        = var.vms_group_memory
      cores         = var.vms_group_cores
      core_fraction = var.vms_group_core_fraction
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = var.vms_group_image_id
        size     = var.vms_group_disk_size
        type     = var.vms_group_disk_type
      }
    }
    network_interface {
      subnet_ids = [yandex_vpc_subnet.public.id]
      nat        = var.vms_group_enable_nat
    }
    scheduling_policy {
      preemptible = var.vms_group_preemptible
    }

    metadata = {
      ssh-keys = "${var.ssh_user_name}:${local.ssh_pub_key}"
      user-data = templatefile("../cloud-init.yaml", {
        logo_url = local.pb_logo_url
      })

    }
  }

  scale_policy {
    fixed_scale {
      size = var.vms_group_size
    }
  }

  allocation_policy {
    zones = [var.default_zone]
  }

  deploy_policy {
    max_unavailable = var.vms_group_deploy_policy.max_unavailable
    max_expansion   = var.vms_group_deploy_policy.max_expansion
  }

  health_check {
    http_options {
      port = var.vms_group_health_check.http_options_port
      path = var.vms_group_health_check.http_options_path
    }
    interval            = var.vms_group_health_check.interval
    timeout             = var.vms_group_health_check.timeout
    unhealthy_threshold = var.vms_group_health_check.unhealthy_threshold
    healthy_threshold   = var.vms_group_health_check.healthy_threshold
  }

  load_balancer {
    target_group_name = "${local.name_prefix}-tg"
  }

  # application_load_balancer {
  #   target_group_name = "${local.name_prefix}-tg"
  # }

  depends_on = [yandex_resourcemanager_folder_iam_member.ig_editor]
}