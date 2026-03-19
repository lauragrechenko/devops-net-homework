resource "yandex_storage_bucket" "pb_bucket" {
  access_key = var.storage_access_key
  secret_key = var.storage_secret_key
  bucket     = "${local.name_prefix}-bucket-${var.s3_bucket_suffix}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.bucket_key.id
        sse_algorithm     = var.kms_sse_algorithm
      }
    }
  }
}

resource "yandex_resourcemanager_folder_iam_member" "sa_kms" {
  folder_id = var.folder_id
  role      = var.kms_iam_role
  member    = "serviceAccount:${var.s3_bucket_sa_id}"
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

resource "yandex_kms_symmetric_key" "bucket_key" {
  name              = "${local.name_prefix}-bucket-key"
  default_algorithm = var.kms_key_algorithm
  rotation_period   = var.kms_key_rotation_period
}