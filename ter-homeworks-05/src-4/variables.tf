variable "ip_address" {
  type        = string
  description = "ip-address"
  validation {
    #condition = can(cidrhost("${var.ip_address}/32", 0))
    condition     = can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", var.ip_address))
    error_message = "Invalid IP address provided."
  }
  #default = "192.168.0.1"
  default = "1920.1680.0.1"
}

variable "ip_list" {
  type        = list(string)
  description = "ip-address list"
  validation {
    condition     = alltrue([for ip in var.ip_list : can(cidrhost("${ip}/32", 0))])
    error_message = "Invalid IP address list provided."
  }

  #default = ["192.168.0.1", "1.1.1.1", "127.0.0.1"]
  default = ["192.168.0.1", "1.1.1.1", "1270.0.0.1"]
}