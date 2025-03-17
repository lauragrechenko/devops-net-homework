### cloud vars

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




### vpc vars

variable "subnets" {
  type = list(object({
    zone = string
    cidr = list(string)
  }))
  description = "List of subnets with zone and CIDR blocks."
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC."
}

variable "vpc_env" {
  type        = string
  default     = "develop"
  description = "The environment name."
}

variable "vpc_security_group_name" {
  type        = string
  description = "Name of the security group."
}

variable "security_group_ingress" {
  type = list(object({
    protocol       = string
    description    = string
    v4_cidr_blocks = list(string)
    port           = number
  }))
  description = "List of ingress rules for the security group."
  default     = []
}

variable "security_group_egress" {
  type = list(object({
    protocol       = string
    description    = string
    v4_cidr_blocks = list(string)
    from_port      = number
    to_port        = number
  }))
  description = "List of egress rules for the security group."
  default     = []
}




# Mysql DB vars

variable "mysql_cluster_name" {
  type        = string
  description = "Name of the MySQL cluster."
}

variable "mysql_db_name" {
  type        = string
  description = "The name of the database."
}

variable "mysql_db_user_name" {
  type        = string
  description = "The name of the user."
}




# Lockbox vars

variable "lockbox_secret_name" {
  type        = string
  description = "The name of the Lockbox secret used to store the DB user's password."
}

variable "lockbox_secret_description" {
  type        = string
  description = "A description for the Lockbox secret."
}

variable "lockbox_iam_member" {
  type        = string
  description = "The full identifier of the account to be granted access to the secret."
}

variable "lockbox_iam_role" {
  type        = string
  description = "The IAM role to assign for accessing the secret."
}

variable "lockbox_entry_key" {
  type        = string
  description = "The key of the entry."
}