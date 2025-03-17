###cloud vars
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

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

###common vars

variable "env_name" {
  type        = string
  default     = "develop"
  description = "The environment name"
}

variable "vms_ssh_root_key" {
  type        = string
  default     = "your_ssh_ed25519_key"
  description = "ssh-keygen -t ed25519"
}

###example vm_web var

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "example vm_web_ prefix"
}

variable "vms_ssh_user" {
  type        = string
  default     = "ubuntu"
  description = "Username for SSH access."
}

variable "vm_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS image family for VM instances"
}

variable "vm_web_nat_enabled" {
  type        = bool
  default     = true
  description = "Enables NAT for the web VM, allowing outbound internet access."
}

variable "vm_web_serial_port_enabled" {
  type        = string
  default     = "0"
  description = "Enables serial port access for debugging and recovery (1 = enabled, 0 = disabled)."
}

variable "vm_configs" {
  type = list(object(
    {
      vm_name = string,
      count   = number,
      labels = object(
        {
          owner   = string
          project = string
        }
      )
    }
  ))
  description = "Map of VM resource configurations for each instance"
}

###S3 var
variable "s3_endpoint" {
  type        = string
  default     = "https://storage.yandexcloud.net"
  description = "S3 endpoint for Yandex Cloud storage"
}

variable "s3_bucket" {
  type        = string
  default     = "default-bucket-name-eq44o4e3"
  description = "The bucket name where the Terraform state is stored"
}

variable "s3_key" {
  type        = string
  default     = "vpc/terraform.tfstate"
  description = "The key (path) in the bucket for the VPC Terraform state file"
}

variable "s3_region" {
  type        = string
  default     = "ru-central1"
  description = "The region for the S3 bucket"
}

variable "skip_region_validation" {
  type        = bool
  default     = true
  description = "Whether to skip region validation for the S3 backend"
}

variable "skip_credentials_validation" {
  type        = bool
  default     = true
  description = "Whether to skip credentials validation for the S3 backend"
}

variable "skip_requesting_account_id" {
  type        = bool
  default     = true
  description = "Skip requesting account ID; required for Terraform 1.6.1 or higher"
}

variable "skip_s3_checksum" {
  type        = bool
  default     = true
  description = "Skip S3 checksum verification; required for Terraform 1.6.3 or higher"
}

variable "access_key" {
  type        = string
  description = "Access key for S3 backend"
}

variable "secret_key" {
  type        = string
  description = "Secret key for S3 backend"
}
