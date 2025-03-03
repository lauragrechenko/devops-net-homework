### VM Web resources vars
variable "vm_web_instance_sufix" {
  type        = string
  default     = "web"
  description = "The sufix assigned to the web VM instance name."
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
  type        = number
  default     = 1
  description = "Enables serial port access for debugging and recovery (1 = enabled, 0 = disabled)."
}


### VM DB resources vars

variable "vm_db_instance_sufix" {
  type        = string
  default     = "db"
  description = "The sufix assigned to the DB VM instance.name"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v2"
  description = "The hardware platform type for the DB VM instance."
}

variable "vm_db_cores" {
  type        = number
  default     = 2
  description = "Number of CPU cores allocated for the DB VM instance."
}

variable "vm_db_memory_gb" {
  type        = number
  default     = 2
  description = "Memory size (in GB) allocated for the DB VM instance."
}

variable "vm_db_core_fraction" {
  type        = number
  default     = 20
  description = "Baseline performance for a core, set as a percent."
}

variable "vm_db_preemptible" {
  type        = bool
  default     = true
  description = "Specifies if the DB VM instance is preemptible."
}

variable "vm_db_nat_enabled" {
  type        = bool
  default     = true
  description = "Enables NAT for the DB VM, allowing outbound internet access."
}

variable "vm_db_serial_port_enabled" {
  type        = number
  default     = 1
  description = "Enables serial port access for debugging and recovery (1 = enabled, 0 = disabled)."
}
