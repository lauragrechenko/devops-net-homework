resource "yandex_alb_load_balancer" "alb" {
  name = "${local.name_prefix}-alb"

  network_id = yandex_vpc_network.this.id

  allocation_policy {
    location {
      zone_id   = var.default_zone
      subnet_id = yandex_vpc_subnet.public.id
    }
  }

  listener {
    name = "${local.name_prefix}-alb-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [var.alb_listener.port]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.alb_router.id
      }
    }
  }

  log_options {
    discard_rule {
      http_code_intervals = var.alb_listener.log_discard_codes
      discard_percent     = var.alb_listener.log_discard_percent
    }
  }
}

resource "yandex_alb_http_router" "alb_router" {
  name = "${local.name_prefix}-alb-http-router"
}

resource "yandex_alb_backend_group" "alb_backend_group" {
  name = "${local.name_prefix}-backend-group"

  http_backend {
    name             = "${local.name_prefix}-http-backend"
    port             = var.alb_backend.port
    target_group_ids = [yandex_compute_instance_group.vms_ig.application_load_balancer[0].target_group_id]

    load_balancing_config {
      panic_threshold = var.alb_backend.panic_threshold
    }
    healthcheck {
      timeout  = var.alb_backend.hc_timeout
      interval = var.alb_backend.hc_interval
      http_healthcheck {
        path = var.alb_backend.hc_path
      }
    }
  }
}

resource "yandex_alb_virtual_host" "my-vhost" {
  name           = "${local.name_prefix}-virtual-host"
  http_router_id = yandex_alb_http_router.alb_router.id
  route {
    name = "${local.name_prefix}-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.alb_backend_group.id
        timeout          = var.alb_backend.route_timeout
      }
    }
  }
}
