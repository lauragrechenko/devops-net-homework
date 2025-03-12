### VM Web resources vars
variable "vm_web_count" {
  type        = number
  default     = 2
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

### VM DB resources vars

variable "each_vm" {
  type = list(object(
    {
      vm_name            = string,
      cpu                = number,
      ram                = number,
      core_fraction      = number,
      disk_volume        = number,
      preemptible        = bool,
      nat_enabled        = bool,
      serial_port_enable = string
    }
  ))
}

### Disk resources vars
variable "vm_disk_name_prefix" {
  type        = string
  default     = "disk"
  description = "Disks name prefix"
}

variable "vm_disk_count" {
  type        = number
  default     = 3
  description = "Number of disks to create"
}

variable "vm_disk_size" {
  type        = number
  default     = 1
  description = "Size of the persistent disk, specified in GB."
}

### VM Storage resources vars
variable "vm_storage_name" {
  type        = string
  default     = "storage-bla"
  description = "Wev VMs name prefix"
}

variable "vm_storage_platform_id" {
  type        = string
  default     = "standard-v2"
  description = "The hardware platform type for the web VM instance."
}

variable "vm_storage_cores" {
  type        = number
  default     = 2
  description = "Number of CPU cores allocated for the web VM instance."
}

variable "vm_storage_memory_gb" {
  type        = number
  default     = 1
  description = "Memory size (in GB) allocated for the web VM instance."
}

variable "vm_storage_core_fraction" {
  type        = number
  default     = 5
  description = "Baseline performance for a core, set as a percent."
}

variable "vm_storage_preemptible" {
  type        = bool
  default     = true
  description = "Specifies if the web VM instance is preemptible."
}

variable "vm_storage_nat_enabled" {
  type        = bool
  default     = true
  description = "Enables NAT for the web VM, allowing outbound internet access."
}

variable "vm_storage_serial_port_enabled" {
  type        = string
  default     = "0"
  description = "Enables serial port access for debugging and recovery (1 = enabled, 0 = disabled)."
}