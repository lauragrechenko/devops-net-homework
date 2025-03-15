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

# DB vars
variable "tfstate_ydb_name" {
  type        = string
  default     = "tfstate-ydb-serverless"
  description = "Name for the YDB serverless database used for Terraform state."
}

variable "tfstate_ydb_deletion_protection" {
  type        = bool
  default     = false
  description = "Enable or disable deletion protection for the YDB serverless database."
}

variable "tfstate_ydb_enable_throttling_rcu_limit" {
  type        = bool
  default     = false
  description = "Enable or disable throttling RCU limit for the YDB database."
}

variable "tfstate_ydb_provisioned_rcu_limit" {
  type        = number
  default     = 10
  description = "Provisioned RCU limit for the YDB serverless database."
}

variable "tfstate_ydb_storage_size_limit" {
  type        = number
  default     = 1
  description = "Storage size limit (in GB) for the YDB serverless database."
}

variable "tfstate_ydb_throttling_rcu_limit" {
  type        = number
  default     = 0
  description = "Throttling RCU limit for the YDB serverless database."
}

variable "tfstate_ydb_role" {
  type        = string
  default     = "ydb.editor"
  description = "The IAM role to assign to the YDB database for state locking."
}

variable "iam_service_account_id" {
  type        = string
  description = "The ID of the Yandex IAM service account to bind to the YDB database."
}

variable "iam_member_prefix" {
  type        = string
  default     = "serviceAccount"
  description = "The prefix for the IAM member type, e.g., serviceAccount or userAccount."
}