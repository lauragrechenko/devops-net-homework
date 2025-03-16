### cloud vars

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


### S3 bucket vars

variable "s3_bucket_name_prefix" {
  type        = string
  default     = "default-bucket-name"
  description = "The name of the bucket."
}

variable "s3_bucket_versioning_enabled" {
  type        = bool
  default     = true
  description = "Enable versioning.  Once you version-enable a bucket, it can never return to an unversioned state."
}

variable "s3_bucket_max_size" {
  type        = number
  default     = 1073741824
  description = "The size of bucket, in bytes."
}


### Random string vars

variable "random_string_length" {
  type        = number
  default     = 8
  description = "Length of the generated random string."
}

variable "random_string_upper" {
  type        = bool
  default     = false
  description = "Include uppercase letters in the random string."
}

variable "random_string_lower" {
  type        = bool
  default     = true
  description = "Include lowercase letters in the random string."
}

variable "random_string_numeric" {
  type        = bool
  default     = true
  description = "Include numeric digits in the random string."
}

variable "random_string_special" {
  type        = bool
  default     = false
  description = "Include special characters in the random string."
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

variable "storage_iam_member_role" {
  type        = string
  default     = "storage.editor"
  description = "The IAM role to assign to the service account for accessing Yandex Object Storage."
}

variable "sa_static_key_description" {
  type        = string
  default     = "Static access key for S3 service account"
  description = "Description for the static access key resource."
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

variable "iam_member_prefix" {
  type        = string
  default     = "serviceAccount"
  description = "The prefix for the IAM member type, e.g., serviceAccount or userAccount."
}