resource "yandex_kms_symmetric_key" "dynamodb_key" {
  name            = var.dynamodb_key_name
  description     = var.dynamodb_key_description
  rotation_period = var.dynamodb_key_rotation_period
}

resource "aws_dynamodb_table" "state_lock_table" {
  name         = var.dynamodb_table_name
  billing_mode = var.dynamodb_table_billing_mode
  hash_key     = var.dynamodb_table_hash_key

  attribute {
    name = var.dynamodb_table_attribute_name
    type = var.dynamodb_table_attribute_type
  }

  server_side_encryption {
    enabled = var.dynamodb_table_sse_enabled
    # have to construct it manually
    kms_key_arn = "arn:yc:kms:${var.aws_region}:${var.cloud_id}:key/${yandex_kms_symmetric_key.dynamodb_key.id}"
  }

  point_in_time_recovery {
    enabled = var.dynamodb_table_pitr_enabled
  }
}
