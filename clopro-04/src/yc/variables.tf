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

# VPC

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "zone_secondary" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "zone_tertiary" {
  type        = string
  default     = "ru-central1-d"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "cidr_public" {
  type        = list(string)
  description = "CIDR blocks for public subnet"
}

variable "cidr_public_secondary" {
  type        = list(string)
  description = "CIDR blocks for public subnet"
}

variable "cidr_public_tertiary" {
  type        = list(string)
  description = "CIDR blocks for public subnet"
}

variable "cidr_private_a" {
  type        = list(string)
  description = "CIDR blocks for private DB subnet in zone A (for MySQL)"
}

variable "cidr_private_b" {
  type        = list(string)
  description = "CIDR blocks for private DB subnet in zone B (for MySQL)"
}

variable "cidr_private_app_a" {
  type        = list(string)
  description = "CIDR blocks for private app subnet in zone A (for K8s nodes)"
}

variable "cidr_private_app_b" {
  type        = list(string)
  description = "CIDR blocks for private app subnet in zone B (for K8s nodes)"
}

variable "cidr_private_app_c" {
  type        = list(string)
  description = "CIDR blocks for private app subnet in zone C (for K8s nodes)"
}

# MYSQL Cluster

variable "cluster_version" {
  type        = string
  default     = "8.0"
  description = "Version of the MySQL cluster. (allowed versions are: 5.7, 8.0)"
}

variable "ha" {
  type        = bool
  default     = true
  description = "Flag for high availability. If true, create hosts for all objects in `host_configs`; if false, create only 1 host for the 1st config."
}

variable "deletion_protection" {
  type        = bool
  default     = true
  description = "The true value means that resource is protected from accidental deletion."
}

variable "resources_preset_id" {
  type        = string
  default     = "b1.medium"
  description = "The ID of the preset for computational resources available to a MySQL host (CPU, memory etc.). For more information, see https://yandex.cloud/en/docs/managed-mysql/concepts/instance-types"
}

variable "resources_disk_size" {
  type        = number
  default     = 20
  description = "Volume of the storage available to a MySQL host, in gigabytes."
}

variable "resources_disk_type_id" {
  type        = string
  default     = "network-hdd"
  description = "Type of the storage of MySQL hosts."
}

variable "db_name" {
  type        = string
  description = "The name of the database."
}

variable "db_user_name" {
  type        = string
  description = "The name of the user."
}

variable "db_user_password" {
  type        = string
  sensitive   = true
  description = "The password of the user."
}

variable "db_user_permissions" {
  type        = list(string)
  default     = ["ALL"]
  description = "Set of permissions granted to the user."
}

variable "db_authentication_plugin" {
  type        = string
  default     = "SHA256_PASSWORD"
  description = "Authentication plugin."
}

variable "backup_window_start" {
  type = object(
    {
      hours   = number,
      minutes = number
    }
  )
  description = "Time to start the daily backup, in the UTC."
}

variable "maintenance_window_type" {
  type        = string
  default     = "ANYTIME"
  description = "Type of maintenance window. Can be either ANYTIME or WEEKLY."
}

# K8s

variable "k8s_version" {
  type        = string
  default     = "1.30"
  description = "Version of Kubernetes that will be used for master."
}

variable "k8s_cluster_region" {
  type        = string
  default     = "ru-central1"
  description = "Name of availability region (e.g. ru-central1), where master instances will be allocated."
}

variable "k8s_cluster_agent_role" {
  type        = string
  default     = "k8s.clusters.agent"
  description = "IAM role for K8s cluster service account"
}

variable "vpc_public_admin_role" {
  type        = string
  default     = "vpc.publicAdmin"
  description = "IAM role for assigning public IPs in VPC"
}

variable "load_balancer_admin_role" {
  type        = string
  default     = "load-balancer.admin"
  description = "IAM role for managing load balancers"
}

variable "k8s_master_public_ip" {
  type        = bool
  default     = true
  description = "When true, Kubernetes master will have visible ipv4 address."
}

variable "k8s_node_platform_id" {
  type        = string
  default     = "standard-v2"
  description = "Platform ID for K8s node instances"
}

variable "k8s_node_memory" {
  type        = number
  default     = 2
  description = "Memory in GB for each K8s node"
}

variable "k8s_node_cores" {
  type        = number
  default     = 2
  description = "CPU cores for each K8s node"
}

variable "k8s_node_disk_type" {
  type        = string
  default     = "network-hdd"
  description = "Disk type for K8s node boot disk"
}

variable "k8s_node_disk_size" {
  type        = number
  default     = 30
  description = "Disk size in GB for K8s node boot disk"
}

variable "k8s_node_preemptible" {
  type        = bool
  default     = true
  description = "Whether K8s nodes are preemptible"
}

variable "k8s_node_container_runtime" {
  type        = string
  default     = "containerd"
  description = "Container runtime for K8s nodes"
}

variable "k8s_node_nat" {
  type        = bool
  default     = true
  description = "Whether to assign public IP to K8s nodes"
}

variable "k8s_node_scale_min" {
  type        = number
  default     = 3
  description = "Minimum number of K8s nodes"
}

variable "k8s_node_scale_max" {
  type        = number
  default     = 6
  description = "Maximum number of K8s nodes"
}

variable "k8s_node_scale_initial" {
  type        = number
  default     = 3
  description = "Initial number of K8s nodes"
}

# KMS
variable "kms_key_algorithm" {
  type        = string
  default     = "AES_256"
  description = "KMS symmetric key algorithm"
}

variable "kms_key_rotation_period" {
  type        = string
  default     = "8760h"
  description = "KMS key rotation period (8760h = 1 year)"
}

variable "kms_sse_algorithm" {
  type        = string
  default     = "aws:kms"
  description = "SSE algorithm for bucket encryption"
}

variable "kms_iam_role" {
  type        = string
  default     = "kms.keys.encrypterDecrypter"
  description = "IAM role for KMS key access"
}

# phpMyAdmin
variable "pma_secret_name" {
  type        = string
  default     = "mysql-creds"
  description = "Name of the Kubernetes secret for phpMyAdmin MySQL credentials"
}

variable "pma_port" {
  type        = string
  default     = "3306"
  description = "MySQL port for phpMyAdmin"
}

variable "pma_replicas" {
  type        = number
  default     = 1
  description = "Number of phpMyAdmin replicas"
}

variable "pma_image" {
  type        = string
  default     = "phpmyadmin/phpmyadmin"
  description = "Docker image for phpMyAdmin"
}

variable "pma_port_http" {
  type        = number
  default     = 80
  description = "HTTP port for phpMyAdmin container"
}