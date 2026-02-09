# ========== General ==========
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "The folder identifier that resource belongs to. https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "project" {
  type        = string
  default     = "clopro"
  description = "Project name used in resource naming"
}

variable "env" {
  type        = string
  default     = "dev"
  description = "Environment name (dev, stage, prod)"
  validation {
    condition     = contains(["dev", "stage", "prod"], var.env)
    error_message = "env must be dev, stage, or prod."
  }
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "cidr_public" {
  type        = list(string)
  description = "CIDR blocks for public subnet"
}

# ========== SSH ==========
variable "ssh_user_name" {
  type        = string
  description = "SSH username for VM access"
}

variable "ssh_pub_key_path" {
  type        = string
  description = "Path to SSH public key file"
}

# ========== Storage ==========
variable "storage_access_key" {
  type        = string
  sensitive   = true
  description = "S3-compatible storage access key"
}

variable "storage_secret_key" {
  type        = string
  sensitive   = true
  description = "S3-compatible storage secret key"
}

variable "pb_logo_source" {
  type        = string
  description = "Local path to the logo image file"
}

variable "pb_logo_key" {
  type        = string
  description = "Object key (filename) for the logo in the bucket"
}

variable "pb_logo_content_type" {
  type        = string
  default     = "image/png"
  description = "MIME type for the logo object"
}

variable "pb_logo_acl" {
  type        = string
  default     = "public-read"
  description = "ACL for the logo object"
}

# ========== Instance Group ==========
variable "vms_group_size" {
  type        = number
  default     = 3
  description = "Number of VMs in the instance group"
}

variable "vms_group_platform_id" {
  type        = string
  default     = "standard-v2"
  description = "Platform ID for instance group VMs"
}

variable "vms_group_cores" {
  type        = number
  default     = 2
  description = "Number of CPU cores for instance group VMs"
}

variable "vms_group_memory" {
  type        = number
  default     = 1
  description = "Memory size in GB for instance group VMs"
}

variable "vms_group_core_fraction" {
  type        = number
  default     = 5
  description = "CPU core fraction (%) for instance group VMs"
  validation {
    condition     = contains([5, 20, 50, 100], var.vms_group_core_fraction)
    error_message = "core_fraction must be 5, 20, 50, or 100."
  }
}

variable "vms_group_preemptible" {
  type        = bool
  default     = true
  description = "Use preemptible (spot) instance for instance group VMs"
}

variable "vms_group_image_id" {
  type        = string
  default     = "fd827b91d99psvq5fjit"
  description = "Yandex Cloud image ID for instance group VMs"
}

variable "vms_group_disk_size" {
  type        = number
  default     = 10
  description = "Boot disk size in GB for instance group VMs (minimum 10 GB)"
  validation {
    condition     = var.vms_group_disk_size >= 10
    error_message = "Boot disk must be at least 10 GB."
  }
}

variable "vms_group_disk_type" {
  type        = string
  default     = "network-hdd"
  description = "Boot disk type for instance group VMs (network-hdd, network-ssd)"
}

variable "vms_group_enable_nat" {
  type        = bool
  default     = false
  description = "Enable public IP (NAT) for instance group VMs"
}

variable "vms_group_deploy_policy" {
  type = object({
    max_unavailable = number
    max_expansion   = number
  })
  default = {
    max_unavailable = 2
    max_expansion   = 2
  }
  description = "Required deploy policy for instance group"
}

variable "vms_group_health_check" {
  type = object({
    http_options_port   = number
    http_options_path   = string
    interval            = number
    timeout             = number
    unhealthy_threshold = number
    healthy_threshold   = number
  })

  default = {
    http_options_port   = 80
    http_options_path   = "/"
    interval            = 15
    timeout             = 5
    unhealthy_threshold = 3
    healthy_threshold   = 2
  }

  description = "Health check specifications."
}

# ========== ALB ==========
variable "alb_listener" {
  type = object({
    port                = number
    log_discard_codes   = list(string)
    log_discard_percent = number
  })
  default = {
    port                = 80
    log_discard_codes   = ["HTTP_2XX"]
    log_discard_percent = 75
  }
  description = "ALB listener and logging configuration"
}

variable "alb_backend" {
  type = object({
    port            = number
    panic_threshold = number
    hc_timeout      = string
    hc_interval     = string
    hc_path         = string
    route_timeout   = string
  })
  default = {
    port            = 80
    panic_threshold = 50
    hc_timeout      = "1s"
    hc_interval     = "1s"
    hc_path         = "/"
    route_timeout   = "3s"
  }
  description = "ALB backend group and healthcheck configuration"
}

# ========== NLB (commented out, kept for reference) ==========
variable "nlb_listener" {
  type = object({
    name       = string
    port       = number
    ip_version = string
  })
  default = {
    name       = "http-listener"
    port       = 80
    ip_version = "ipv4"
  }
  description = "Network load balancer listener configuration"
}

variable "nlb_healthcheck" {
  type = object({
    name = string
    port = number
    path = string
  })
  default = {
    name = "http"
    port = 80
    path = "/"
  }
  description = "Network load balancer healthcheck configuration"
}
