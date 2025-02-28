###cloud vars


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
  description = "VPC network & subnet name"
}


###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIELR69LvbgRZaTyYcvL3f70oCf+l86UPTRG27wG6Vau0 laura-grechenko@Awesome-7560"
  description = "ssh-keygen -t ed25519"
}

variable "vms_ssh_user" {
  type        = string
  default     = "ubuntu"
  description = "Username for SSH access."
}

### VM Web resources vars

variable "vm_web_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS image family for the web VM instance"
}

variable "vm_web_instance_name" {
  type = string
  default = "netology-develop-platform-web"
  description = "The name assigned to the web VM instance."
}

variable "vm_web_platform_id" {
  type = string
  default = "standard-v2"
  description = "The hardware platform type for the web VM instance."
}

variable "vm_web_cores" {
  type        = number
  default     = 2
  description = "Number of CPU cores allocated for the web VM instance."
}

variable "vm_web_memory_gb" {
  type        = number
  default     = 1
  description = "Memory size (in GB) allocated for the web VM instance."
}

variable "vm_web_core_fraction" {
  type        = number
  default     = 5
  description = "Baseline performance for a core, set as a percent."
}

variable "vm_web_preemptible" {
  type        = bool
  default     = true
  description = "Specifies if the web VM instance is preemptible."
}

variable "vm_web_nat_enabled" {
  type        = bool
  default     = true
  description = "Enables NAT for the web VM, allowing outbound internet access."
}

variable "vm_web_serial_port_enabled" {
  type        = number
  default     = 1
  description = "Enables serial port access for debugging and recovery (1 = enabled, 0 = disabled)."
}