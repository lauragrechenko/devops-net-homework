resource "kubernetes_secret_v1" "mysql_creds" {
  metadata {
    name = var.pma_secret_name
  }

  data = {
    PMA_HOST     = aws_db_instance.mysql.address
    PMA_PORT     = tostring(var.db_port)
    PMA_USER     = var.db_username
    PMA_PASSWORD = var.db_password
  }
}

resource "kubernetes_deployment_v1" "phpmyadmin" {
  metadata {
    name = "phpmyadmin"
    labels = {
      app = "phpmyadmin"
    }
  }

  spec {
    replicas = var.pma_replicas

    selector {
      match_labels = {
        app = "phpmyadmin"
      }
    }

    template {
      metadata {
        labels = {
          app = "phpmyadmin"
        }
      }

      spec {
        container {
          name  = "phpmyadmin"
          image = var.pma_image

          port {
            container_port = var.pma_port_http
          }

          env {
            name = "PMA_HOST"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.mysql_creds.metadata[0].name
                key  = "PMA_HOST"
              }
            }
          }

          env {
            name = "PMA_PORT"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.mysql_creds.metadata[0].name
                key  = "PMA_PORT"
              }
            }
          }

          env {
            name = "PMA_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.mysql_creds.metadata[0].name
                key  = "PMA_USER"
              }
            }
          }

          env {
            name = "PMA_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.mysql_creds.metadata[0].name
                key  = "PMA_PASSWORD"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "phpmyadmin_lb" {
  metadata {
    name = "phpmyadmin-lb"
  }

  spec {
    type     = "LoadBalancer"
    selector = { app = "phpmyadmin" }

    port {
      port        = var.pma_port_http
      target_port = var.pma_port_http
    }
  }
}
