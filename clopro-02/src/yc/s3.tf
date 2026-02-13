resource "yandex_storage_bucket" "pb_bucket" {
  access_key = var.storage_access_key
  secret_key = var.storage_secret_key
  bucket     = "${local.name_prefix}-bucket-${var.s3_bucket_suffix}"
}

resource "yandex_storage_object" "pb_logo" {
  bucket       = yandex_storage_bucket.pb_bucket.bucket
  key          = var.pb_logo_key
  source       = var.pb_logo_source
  content_type = var.pb_logo_content_type

  acl        = var.pb_logo_acl
  access_key = var.storage_access_key
  secret_key = var.storage_secret_key
}