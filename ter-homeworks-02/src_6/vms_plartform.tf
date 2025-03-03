### VM Web resources vars
variable "vm_web_instance_sufix" {
  type        = string
  default     = "platform-web"
  description = "The sufix assigned to the web VM instance name."
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v2"
  description = "The hardware platform type for the web VM instance."
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


### VM DB resources vars

variable "vm_db_instance_sufix" {
  type        = string
  default     = "platform-db"
  description = "The sufix assigned to the DB VM instance.name"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v2"
  description = "The hardware platform type for the DB VM instance."
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
