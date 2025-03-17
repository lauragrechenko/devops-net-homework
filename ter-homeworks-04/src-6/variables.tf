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

### S3 bucket vars
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