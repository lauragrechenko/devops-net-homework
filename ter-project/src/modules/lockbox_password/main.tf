terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "~>1.10.5"
}

resource "random_password" "this" {
  length  = var.password_length
  special = var.password_special
}

resource "yandex_lockbox_secret" "this" {
  name                = var.secret_name
  description         = var.secret_description
}

resource "yandex_lockbox_secret_iam_member" "this" {
  secret_id = yandex_lockbox_secret.this.id
  role      = var.iam_role
  member = var.iam_member
}

resource "yandex_lockbox_secret_version" "this" {
  secret_id             = yandex_lockbox_secret.this.id
  entries {
    key        = var.entry_key
    text_value = random_password.this.result
  }
}