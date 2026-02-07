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
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "cidr_public" {
  type        = list(string)
  description = "CIDR blocks for public subnet"
}

variable "cidr_private" {
  type        = list(string)
  description = "CIDR blocks for private subnet"
}

# SSH user
variable "ssh_user_name" {
  type        = string
  description = "SSH username for VM access"
}

variable "ssh_pub_key_path" {
  type        = string
  description = "Path to SSH public key file"
}

# VM NAT vars

variable "vm_nat_platform_id" {
  type        = string
  default     = "standard-v2"
  description = "Platform ID for NAT instance (standard-v1, standard-v2, standard-v3)"
}

variable "vm_nat_ip_address" {
  type        = string
  default     = "192.168.10.254"
  description = "Internal IP address for NAT instance in public subnet"
}

variable "vm_nat_cores" {
  type        = number
  default     = 2
  description = "Number of CPU cores for NAT instance"
}

variable "vm_nat_memory" {
  type        = number
  default     = 1
  description = "Memory size in GB for NAT instance"
}

variable "vm_nat_core_fraction" {
  type        = number
  default     = 5
  description = "CPU core fraction (%) for NAT instance"
}

variable "vm_nat_preemptible" {
  type        = bool
  default     = true
  description = "Use preemptible (spot) instance for NAT"
}

variable "vm_nat_image_id" {
  type        = string
  default     = "fd80mrhj8fl2oe87o4e1"
  description = "Yandex Cloud image ID for NAT instance"
}

variable "vm_nat_disk_size" {
  type        = number
  default     = 5
  description = "Boot disk size in GB for NAT instance"
}

variable "vm_nat_disk_type" {
  type        = string
  default     = "network-hdd"
  description = "Boot disk type for NAT instance (network-hdd, network-ssd)"
}

variable "vm_nat_enable_nat" {
  type        = bool
  default     = true
  description = "Enable public IP (NAT) for NAT instance"
}


# Public Vm specific vars

variable "vm_public_platform_id" {
  type        = string
  default     = "standard-v2"
  description = "Platform ID for public test VM"
}

variable "vm_public_cores" {
  type        = number
  default     = 2
  description = "Number of CPU cores for public test VM"
}

variable "vm_public_memory" {
  type        = number
  default     = 1
  description = "Memory size in GB for public test VM"
}

variable "vm_public_core_fraction" {
  type        = number
  default     = 5
  description = "CPU core fraction (%) for public test VM"
}

variable "vm_public_preemptible" {
  type        = bool
  default     = true
  description = "Use preemptible (spot) instance for public test VM"
}

variable "vm_public_image_id" {
  type        = string
  default     = "fd8vhban0amqsqutsjk7"
  description = "Yandex Cloud image ID for public test VM"
}

variable "vm_public_disk_size" {
  type        = number
  default     = 10
  description = "Boot disk size in GB for public test VM (minimum 10 GB)"
}

variable "vm_public_disk_type" {
  type        = string
  default     = "network-hdd"
  description = "Boot disk type for public test VM (network-hdd, network-ssd)"
}

variable "vm_public_enable_nat" {
  type        = bool
  default     = true
  description = "Enable public IP (NAT) for public test VM"
}

# Private Vm specific vars

variable "vm_private_platform_id" {
  type        = string
  default     = "standard-v2"
  description = "Platform ID for private test VM"
}

variable "vm_private_cores" {
  type        = number
  default     = 2
  description = "Number of CPU cores for private test VM"
}

variable "vm_private_memory" {
  type        = number
  default     = 1
  description = "Memory size in GB for private test VM"
}

variable "vm_private_core_fraction" {
  type        = number
  default     = 5
  description = "CPU core fraction (%) for private test VM"
}

variable "vm_private_preemptible" {
  type        = bool
  default     = true
  description = "Use preemptible (spot) instance for private test VM"
}

variable "vm_private_image_id" {
  type        = string
  default     = "fd8vhban0amqsqutsjk7"
  description = "Yandex Cloud image ID for private test VM"
}

variable "vm_private_disk_size" {
  type        = number
  default     = 10
  description = "Boot disk size in GB for private test VM (minimum 10 GB)"
}

variable "vm_private_disk_type" {
  type        = string
  default     = "network-hdd"
  description = "Boot disk type for private test VM (network-hdd, network-ssd)"
}

variable "vm_private_enable_nat" {
  type        = bool
  default     = true
  description = "Enable public IP (NAT) for private test VM"
}