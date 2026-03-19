locals {
  name_prefix = "${var.project}-${var.env}"
  pb_logo_url = "https://${yandex_storage_bucket.pb_bucket.bucket}.storage.yandexcloud.net/${yandex_storage_object.pb_logo.key}"
}