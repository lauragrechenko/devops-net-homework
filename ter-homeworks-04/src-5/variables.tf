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

variable "zone_b" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "cidr_2" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
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

### mysql cluster vars

variable "mysql_env" {
  type        = string
  default     = "PRESTABLE"
  description = "Deployment environment of the MySQL cluster."
}

variable "mysql_cluster_name" {
  type        = string
  default     = "mysql-cluster"
  description = "Name of the MySQL cluster."
}

variable "mysql_ha_available" {
  type        = bool
  default     = false
  description = "Flag for high availability. If true, create hosts for all objects in `host_configs`; if false, create only 1 host for the 1st config."
}

variable "mysql_cluster_version" {
  type        = string
  default     = "8.0"
  description = "Version of the MySQL cluster. (allowed versions are: 5.7, 8.0)"
}

variable "mysql_cluster_resources_preset_id" {
  type        = string
  default     = "b2.medium"
  description = "The ID of the preset for computational resources available to a MySQL host (CPU, memory etc.). For more information, see https://yandex.cloud/en/docs/managed-mysql/concepts/instance-types"
}

variable "mysql_cluster_resources_disk_size" {
  type        = number
  default     = 10
  description = "Volume of the storage available to a MySQL host, in gigabytes."
}

variable "mysql_cluster_resources_disk_type_id" {
  type        = string
  default     = "network-hdd"
  description = "Type of the storage of MySQL hosts."
}

### mysql DB vars
variable "mysql_db_name" {
  type        = string
  default     = "test_db"
  description = "The name of the database."
}

variable "mysql_db_user_name" {
  type        = string
  description = "The name of the user."
}

variable "mysql_db_user_password" {
  type        = string
  sensitive   = true
  description = "The password of the user."
}