variable "vpc_name" {
  type        = string
  description = "The name of the VPC network."
}

variable "subnet_cidr" {
  type        = list(string)
  description = "A block of internal IPv4 addresses that are owned by this subnet."
}

variable "subnet_zone" {
  type        = string
  description = "Name of the Yandex Cloud zone for this subnet."
}