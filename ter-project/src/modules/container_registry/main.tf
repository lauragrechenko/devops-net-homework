terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "~>1.10.5"
}

resource "yandex_container_registry" "this" {
  name = var.container_registry_name
}

resource "yandex_container_repository" "this" {
  name = "${yandex_container_registry.this.id}/${var.container_repository_name}"
}

resource "yandex_container_repository_iam_binding" "this" {
  for_each      = toset(var.container_registry_roles)
  repository_id = yandex_container_repository.this.id
  role          = each.value
  members       = ["${var.iam_member_prefix}:${var.service_account_id}"]
}