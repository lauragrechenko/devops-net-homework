resource "random_string" "unique_id" {
  length  = var.random_string_length
  upper   = var.random_string_upper
  lower   = var.random_string_lower
  numeric = var.random_string_numeric
  special = var.random_string_special
}

module "s3" {
  source = "git::https://github.com/terraform-yc-modules/terraform-yc-s3.git"

  bucket_name = "${var.s3_bucket_name_prefix}-${random_string.unique_id.result}"
  max_size    = var.s3_bucket_max_size
  versioning = {
    enabled = var.s3_bucket_versioning_enabled
  }
}