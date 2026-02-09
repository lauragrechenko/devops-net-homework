resource "yandex_lb_network_load_balancer" "nlb" {
  name = "${local.name_prefix}-nlb"

  listener {
    name = var.nlb_listener.name
    port = var.nlb_listener.port
    external_address_spec {
      ip_version = var.nlb_listener.ip_version
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.vms_ig.load_balancer[0].target_group_id

    healthcheck {
      name = var.nlb_healthcheck.name
      http_options {
        port = var.nlb_healthcheck.port
        path = var.nlb_healthcheck.path
      }
    }
  }
}