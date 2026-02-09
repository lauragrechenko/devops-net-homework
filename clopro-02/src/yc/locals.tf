locals {
  name_prefix = "${var.project}-${var.env}"
  ssh_pub_key = file("${var.ssh_pub_key_path}")

  pb_logo_url = "https://${yandex_storage_bucket.pb_bucket.bucket}.storage.yandexcloud.net/${yandex_storage_object.pb_logo.key}"
}