variable "vm_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS image family for VM instances"
}

variable "vm_count" {
  type        = number
  default     = 1
  description = "Number of Web VMs to create"
}

variable "vm_name_prefix" {
  type        = string
  default     = "web"
  description = "Wev VMs name prefix"
}

variable "vm_platform_id" {
  type        = string
  default     = "standard-v2"
  description = "The hardware platform type for the  VM instance."
}

variable "vm_cores" {
  type        = number
  default     = 2
  description = "Number of CPU cores allocated for the  VM instance."
}

variable "vm_memory_gb" {
  type        = number
  default     = 1
  description = "Memory size (in GB) allocated for the  VM instance."
}

variable "vm_core_fraction" {
  type        = number
  default     = 5
  description = "Baseline performance for a core, set as a percent."
}

variable "vm_preemptible" {
  type        = bool
  default     = true
  description = "Specifies if the  VM instance is preemptible."
}

variable "vm_nat_enabled" {
  type        = bool
  default     = true
  description = "Enables NAT for the  VM, allowing outbound internet access."
}

variable "vm_metadata" {
  description = "For dynamic block 'metadata' "
  type        = map(string)
}

variable "vpc_subnet_id" {
  type        = string
  description = "The ID of the VPC subnet where the instance will be created."
}

variable "security_group_ids" {
  type        = list(string)
  description = "A list of security group IDs to attach to the  instance."
  default     = []
}

variable "service_account_id" {
  type        = string
  description = "The id of the service account for VM access to the Container Registry."
  default     = "vm-service-account"
}

variable "iam_member_prefix" {
  type        = string
  default     = "serviceAccount"
  description = "The prefix for the IAM member type, e.g., serviceAccount or userAccount."
}

variable "registry_puller_role" {
  type        = string
  description = "The IAM role used for pulling container images from the registry."
  default     = "container-registry.images.puller"
}

variable "container_registry_id" {
  type        = string
  description = "The Yandex Container Registry ID to apply a binding to."
}
