# ========== General ==========
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "The folder identifier that resource belongs to. https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "project" {
  type        = string
  default     = "clopro"
  description = "Project name used in resource naming"
}

variable "env" {
  type        = string
  default     = "dev"
  description = "Environment name (dev, stage, prod)"
  validation {
    condition     = contains(["dev", "stage", "prod"], var.env)
    error_message = "env must be dev, stage, or prod."
  }
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

# ========== Storage ==========
variable "storage_access_key" {
  type        = string
  sensitive   = true
  description = "S3-compatible storage access key"
}

variable "storage_secret_key" {
  type        = string
  sensitive   = true
  description = "S3-compatible storage secret key"
}

variable "s3_bucket_suffix" {
  type        = string
  default     = "laura-08-02-26"
  description = "Unique suffix for S3 bucket name"
}

variable "s3_bucket_sa_id" {
  type        = string
  description = "Service account ID for bucket access"
}

variable "pb_logo_source" {
  type        = string
  description = "Local path to the logo image file"
}

variable "pb_logo_key" {
  type        = string
  description = "Object key (filename) for the logo in the bucket"
}

variable "pb_logo_content_type" {
  type        = string
  default     = "image/png"
  description = "MIME type for the logo object"
}

variable "pb_logo_acl" {
  type        = string
  default     = "public-read"
  description = "ACL for the logo object"
}

# ========== KMS ==========
variable "kms_key_algorithm" {
  type        = string
  default     = "AES_256"
  description = "KMS symmetric key algorithm"
}

variable "kms_key_rotation_period" {
  type        = string
  default     = "8760h"
  description = "KMS key rotation period (8760h = 1 year)"
}

variable "kms_sse_algorithm" {
  type        = string
  default     = "aws:kms"
  description = "SSE algorithm for bucket encryption"
}

variable "kms_iam_role" {
  type        = string
  default     = "kms.keys.encrypterDecrypter"
  description = "IAM role for KMS key access"
}
