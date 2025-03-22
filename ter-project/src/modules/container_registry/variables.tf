variable "container_registry_name" {
  type        = string
  description = "The name of the container registry."
  default     = "project-registry"
}

variable "container_repository_name" {
  type        = string
  description = "The name of the container repository inside the registry."
  default     = "project-repository"
}

variable "container_registry_roles" {
  type        = list(string)
  description = "The IAM roles to work with container images."
  default     = ["container-registry.images.pusher", "container-registry.images.puller"]
}

variable "iam_member_prefix" {
  type        = string
  description = "The IAM member prefix, such as 'serviceAccount' or 'userAccount'."
  default     = "serviceAccount"
}

variable "service_account_id" {
  type        = string
  description = "The service account ID that will be granted pull permissions for the container repository."
}