### Cloud vars

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
  default     = "ru-central1-d"
  description = "Default availability zone"
}

### Network

variable "vpc_name" {
  type        = string
  default     = "k8s-hw"
  description = "The name of the VPC."
}

variable "vpc_env" {
  type        = string
  default     = "dev"
  description = "Environment name."
}

variable "vpc_subnet_cidr" {
  type        = string
  default     = "10.10.0.0/24"
  description = "CIDR for single subnet."
}

### VM vars

variable "vms_ssh_user" {
  type        = string
  default     = "ubuntu"
  description = "Username for SSH access."
}

variable "vms_ssh_root_key" {
  type        = string
  default     = "~/.ssh/id_ed25519_yc_test.pub"
  description = "ssh-keygen -t ed25519"
}

variable "vm_image_id" {
  type        = string
  description = "Ubuntu 20.04 LTS image id in Yandex Cloud"
}

variable "vm_cpu_fraction" {
  type        = number
  default     = 5
  description = "Guaranteed vCPU performance percentage (5-100)."
}

variable "vm_preemptible" {
  type        = bool
  default     = true
  description = "Whether instances should be preemptible."
}


# Cluster size
variable "master_count" {
  type        = number
  description = "Number of master nodes."
}

variable "worker_count" {
  type        = number
  description = "Number of worker nodes."
}

# Master resources
variable "master_cores" {
  type        = number
  default     = 2
  description = "Number of vCPUs for each master node."
}

variable "master_memory_gb" {
  type        = number
  default     = 2
  description = "Memory (GB) for each master node."
}

variable "master_disk_size_gb" {
  type        = number
  default     = 10
  description = "Boot disk size (GB) for each master node."
}

# Worker resources
variable "worker_cores" {
  type        = number
  default     = 2
  description = "Number of vCPUs for each worker node."
}

variable "worker_memory_gb" {
  type        = number
  default     = 2
  description = "Memory (GB) for each worker node."
}

variable "worker_disk_size_gb" {
  type        = number
  default     = 10
  description = "Boot disk size (GB) for each worker node."
}

variable "vm_platform_id" {
  type        = string
  default     = "standard-v2"
  description = "Yandex Cloud platform_id for compute instances."
}
