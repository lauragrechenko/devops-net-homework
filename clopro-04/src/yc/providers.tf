terraform {
  required_version = ">= 1.5"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex",
      version = "~> 0.121"
    }
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}

data "yandex_client_config" "client" {}

provider "kubernetes" {
  host                   = yandex_kubernetes_cluster.regional_cluster.master[0].external_v4_endpoint
  cluster_ca_certificate = yandex_kubernetes_cluster.regional_cluster.master[0].cluster_ca_certificate
  token                  = data.yandex_client_config.client.iam_token
}