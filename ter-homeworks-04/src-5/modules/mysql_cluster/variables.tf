variable "cluster_name" {
  type        = string
  description = "Name of the MySQL cluster."
}

variable "env_name" {
  type        = string
  default     = "ENVIRONMENT_UNSPECIFIED"
  description = "Deployment environment of the MySQL cluster."
}

variable "network_id" {
  type        = string
  description = "ID of the network, to which the MySQL cluster uses."
}

variable "cluster_version" {
  type        = string
  default     = "8.0"
  description = "Version of the MySQL cluster. (allowed versions are: 5.7, 8.0)"
}

variable "resources_preset_id" {
  type        = string
  default     = "b2.medium"
  description = "The ID of the preset for computational resources available to a MySQL host (CPU, memory etc.). For more information, see https://yandex.cloud/en/docs/managed-mysql/concepts/instance-types"
}

variable "resources_disk_size" {
  type        = number
  default     = 10
  description = "Volume of the storage available to a MySQL host, in gigabytes."
}

variable "resources_disk_type_id" {
  type        = string
  default     = "network-hdd"
  description = "Type of the storage of MySQL hosts."
}

variable "host_configs" {
  type = list(object(
    {
      zone      = string,
      subnet_id = string
    }
  ))
  description = "List of host configurations for the MySQL cluster, each containing the zone and subnet ID for the host."
}

variable "ha" {
  type        = bool
  default     = true
  description = "Flag for high availability. If true, create hosts for all objects in `host_configs`; if false, create only 1 host for the 1st config."
}