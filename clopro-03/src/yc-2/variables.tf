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

variable "s3_bucket_sa_id" {
  type        = string
  description = "Service account ID for bucket access"
}

# ========== Website ==========
variable "website_index_document" {
  type        = string
  default     = "index.html"
  description = "Index document for static website hosting"
}

variable "website_index_source" {
  type        = string
  default     = "./index.html"
  description = "Local path to the index.html file"
}

variable "website_index_content_type" {
  type        = string
  default     = "text/html"
  description = "Content-Type for the index document"
}

variable "website_acl" {
  type        = string
  default     = "public-read"
  description = "ACL for website objects"
}

# ========== Domain ==========
variable "domain_name" {
  type        = string
  default     = "openjar.xyz"
  description = "Root domain name"
}

variable "website_subdomain" {
  type        = string
  default     = "www"
  description = "Subdomain for static website"
}

# ========== Logo ==========
variable "pb_logo_key" {
  type        = string
  default     = "pb-logo.png"
  description = "Object key for the logo in the bucket"
}

variable "pb_logo_source" {
  type        = string
  default     = "./pb-logo.png"
  description = "Local path to the logo image file"
}

variable "pb_logo_content_type" {
  type        = string
  default     = "image/png"
  description = "Content-Type for the logo file"
}
