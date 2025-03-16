terraform {
  required_providers {
    assert = {
      source  = "hashicorp/assert"
      version = ">= 0.3.0"
    }
  }
}

variable "example" {
  type        = string
  description = "Example to validate lowercase validation."
  validation {
    condition     = provider::assert::lowercased(var.example)
    error_message = "Example must be lowercased"
  }

  #validation {
  #  condition = (
  #    var.example == lower(var.example)
  #  )
  #  error_message = "Example must be lowercased."
  #}

  #default = "valid case"
  default = "inValid Case"
}

variable "only_one" {
  description = "Who is better Connor or Duncan?"
  type = object({
    Dunkan = optional(bool)
    Connor = optional(bool)
  })

  default = {
    Dunkan = true
    Connor = true
  }

  validation {
    error_message = "There can be only one MacLeod"
    condition     = var.only_one["Dunkan"] != var.only_one["Connor"]
  }
}