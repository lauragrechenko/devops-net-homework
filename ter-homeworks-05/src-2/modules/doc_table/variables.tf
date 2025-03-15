variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

# AWS Vars
variable "aws_region" {
  type        = string
  default     = "ru-central1"
  description = "AWS region for the provider (Yandex Cloud uses ru-central1)."
}

variable "aws_profile" {
  type        = string
  default     = "yandex"
  description = "Profile name in ~/.aws/credentials containing Yandex Cloud static access keys."
}

variable "aws_shared_credentials_file" {
  type        = string
  default     = "~/.aws/credentials"
  description = "Path to the shared AWS credentials file."
}

# DynamoDB Vars
variable "ydb_database_path" {
  type        = string
  description = "Path to YDB database."
}

# DynamoDB Table Vars
variable "dynamodb_table_name" {
  type        = string
  default     = "state-lock-table"
  description = "Name of the DynamoDB table for state locking."
}

variable "dynamodb_table_billing_mode" {
  type        = string
  default     = "PAY_PER_REQUEST"
  description = "Billing mode for the DynamoDB table."
}

variable "dynamodb_table_hash_key" {
  type        = string
  default     = "LockID"
  description = "The primary (hash) key for the DynamoDB table."
}

variable "dynamodb_table_attribute_name" {
  type        = string
  default     = "LockID"
  description = "Attribute name for the primary key."
}

variable "dynamodb_table_attribute_type" {
  type        = string
  default     = "S"
  description = "Data type of the attribute (e.g., S for String)."
}

variable "dynamodb_key_name" {
  type        = string
  default     = "dynamodb-key"
  description = "Name for the KMS key used to encrypt the DynamoDB-compatible document table."
}

variable "dynamodb_key_description" {
  type        = string
  default     = "KMS key for encrypting the DynamoDB-compatible document table"
  description = "Description for the KMS key used for encrypting the DynamoDB-compatible document table."
}

variable "dynamodb_key_rotation_period" {
  type        = string
  default     = "8760h" // 1 year in hours
  description = "Rotation period for the KMS key. '8760h' equals one year."
}

variable "dynamodb_table_sse_enabled" {
  type        = bool
  default     = true
  description = "Enable server-side encryption for the DynamoDB table."
}

variable "dynamodb_table_pitr_enabled" {
  type        = bool
  default     = true
  description = "Enable point-in-time recovery for the DynamoDB table."
}