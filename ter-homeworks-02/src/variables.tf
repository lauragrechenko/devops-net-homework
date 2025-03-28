###cloud vars

variable "vms_resources" {
  type = map(
    object({
      cores         = number
      memory_gb     = number
      core_fraction = number
    })
  )
  description = "Map of VM resource configurations for each instance"
}

variable "metadata" {
  type        = map(string)
  description = "Metadata key/value pairs to make available from within the instance."
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

### VPC Network

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "zone_b" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "db_subnet_cidr" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

### VPC Gateway

variable "vpc_gateway_name" {
  type        = string
  default     = "nat-gateway"
  description = "Name of the VPC Gateway"
}

variable "vpc_route_table_name" {
  type        = string
  default     = "test-route-table"
  description = "Name of the route table."
}

variable "vpc_route_table_destination_prefix" {
  type        = string
  default     = "0.0.0.0/0"
  description = "Route prefix in CIDR notation."
}

variable "vm_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS image family for VM instances"
}

### Task 8

variable "test" {
  type        = list(map(list(string)))
  description = "Test variable from the task 8"
}