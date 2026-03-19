resource "yandex_storage_bucket" "pb_bucket" {
  access_key = var.storage_access_key
  secret_key = var.storage_secret_key
  bucket     = local.website_fqdn

  website {
    index_document = var.website_index_document
  }

  anonymous_access_flags {
    read        = true
    list        = false
    config_read = false
  }
}

resource "yandex_storage_object" "index" {
  bucket       = yandex_storage_bucket.pb_bucket.bucket
  key          = var.website_index_document
  source       = var.website_index_source
  content_type = var.website_index_content_type

  acl        = var.website_acl
  access_key = var.storage_access_key
  secret_key = var.storage_secret_key
}

resource "yandex_storage_object" "pb_logo" {
  bucket       = yandex_storage_bucket.pb_bucket.bucket
  key          = var.pb_logo_key
  source       = var.pb_logo_source
  content_type = var.pb_logo_content_type

  acl        = var.website_acl
  access_key = var.storage_access_key
  secret_key = var.storage_secret_key
}
