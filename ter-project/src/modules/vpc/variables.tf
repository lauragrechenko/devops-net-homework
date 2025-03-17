variable "vpc_name" {
  type        = string
  description = "The name of the VPC network."
}

variable "subnets" {
  type = list(object({
    zone = string
    cidr = list(string)
  }))
  description = "List of subnets to create with zone, cidr."
}

variable "env_name" {
  type        = string
  default     = null
  description = "The environment name."
}