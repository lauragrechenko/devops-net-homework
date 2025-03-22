variable "cluster_id" {
  type        = string
  description = "ID of the MySQL cluster."
}

variable "db_name" {
  type        = string
  description = "The name of the database."
}

variable "user_name" {
  type        = string
  description = "The name of the user."
}

variable "user_password" {
  type        = string
  description = "The password of the user."
}

variable "authentication_plugin" {
  type        = string
  default     = "SHA256_PASSWORD"
  description = "Authentication plugin."
}

variable "user_permission" {
  type        = list(string)
  default     = ["ALL"]
  description = "List user's roles in the database."
}