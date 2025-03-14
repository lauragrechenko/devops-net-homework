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

# iam vars
variable "sa_name" {
  type        = string
  default     = "s3-service-account"
  description = "The name for the service account used for S3 operations."
}

variable "sa_description" {
  type        = string
  default     = "Service account to work with S3"
  description = "Description for the service account."
}

variable "iam_member_role" {
  type        = string
  default     = "storage.editor"
  description = "The IAM role to assign to the service account."
}

variable "sa_static_key_description" {
  type        = string
  default     = "Static access key for S3 service account"
  description = "Description for the static access key resource."
}