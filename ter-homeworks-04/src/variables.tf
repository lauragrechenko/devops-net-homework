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
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
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

###example vm_db var
variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "example vm_db_ prefix"
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

variable "cloudinit_packages" {
  type        = list(string)
  description = "List of packages to install via cloud-init."
  default     = ["vim", "nginx"]
}