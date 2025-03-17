variable "vm_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS image family for VM instances"
}

variable "vm_web_count" {
  type        = number
  default     = 1
  description = "Number of Web VMs to create"
}

variable "vm_web_name_prefix" {
  type        = string
  default     = "web"
  description = "Wev VMs name prefix"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v2"
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
  type        = string
  default     = "0"
  description = "Enables serial port access for debugging and recovery (1 = enabled, 0 = disabled)."
}

variable "vpc_subnet_id" {
  type        = string
  description = "The ID of the VPC subnet where the instance will be created."
}

variable "security_group_ids" {
  type        = list(string)
  description = "A list of security group IDs to attach to the web instance."
  default     = []
}

variable "vms_ssh_user" {
  type        = string
  description = "The username to use for SSH access to the instance."
  default     = "ubuntu"
}

variable "ssh_pub_key" {
  type        = string
  description = "The SSH public key that will be added to the instance for access."
}