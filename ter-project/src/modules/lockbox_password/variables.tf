# Lockbox vars
variable "secret_name" {
  type        = string
  description = "The name of the Lockbox secret used to store the DB user's password."
}

variable "secret_description" {
  type        = string
  description = "A description for the Lockbox secret."
}

variable "iam_member_prefix" {
  type        = string
  description = "The IAM member prefix, such as 'serviceAccount' or 'userAccount'."
  default     = "serviceAccount"
}

variable "service_account_id" {
  type        = string
  description = "The service account ID that will be granted access to the secret."
}

variable "iam_roles" {
  type        = list(string)
  description = "The IAM role to assign for accessing the secret."
  default     = ["lockbox.editor", "lockbox.payloadViewer"]
}

variable "entry_key" {
  type        = string
  description = "The IAM role to assign for accessing the secret."
}

# Password vars
variable "password_length" {
  type        = number
  description = "The length of the generated DB password."
  default     = 16
}

variable "password_special" {
  type        = bool
  description = "Whether to include special characters in the generated DB password."
  default     = true
}