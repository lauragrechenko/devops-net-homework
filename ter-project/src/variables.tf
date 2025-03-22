### cloud vars

variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}




### vpc vars

variable "vpc_subnets" {
  type = list(object({
    zone = string
    cidr = list(string)
  }))
  description = "List of subnets with zone and CIDR blocks."
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC."
}

variable "vpc_env" {
  type        = string
  default     = "develop"
  description = "The environment name."
}

variable "security_group_name" {
  type        = string
  description = "Name of the security group."
}

variable "security_group_ingress" {
  type = list(object({
    protocol       = string
    description    = string
    v4_cidr_blocks = list(string)
    port           = number
  }))
  description = "List of ingress rules for the security group."
  default     = []
}

variable "security_group_egress" {
  type = list(object({
    protocol       = string
    description    = string
    v4_cidr_blocks = list(string)
    from_port      = number
    to_port        = number
  }))
  description = "List of egress rules for the security group."
  default     = []
}




# Mysql DB vars

variable "mysql_cluster_name" {
  type        = string
  description = "Name of the MySQL cluster."
}

variable "mysql_db_name" {
  type        = string
  description = "The name of the database."
}

variable "mysql_db_user_name" {
  type        = string
  description = "The name of the user."
}



# Repo registry vars

variable "registry_service_account_id" {
  type        = string
  description = "The service account ID that will be granted access to the registry."
}



# Lockbox vars

variable "lockbox_db_secret_name" {
  type        = string
  description = "The name of the Lockbox secret used to store the DB user's password."
}

variable "lockbox_db_secret_description" {
  type        = string
  description = "A description for the Lockbox secret."
}

variable "lockbox_db_entry_key" {
  type        = string
  description = "The key of the entry."
}

variable "lockbox_db_service_account_id" {
  type        = string
  description = "The service account ID that will be granted access to the secret."
}



# VM vars

variable "vms_ssh_user" {
  type        = string
  default     = "ubuntu"
  description = "Username for SSH access."
}

variable "vm_web_cloudinit_packages" {
  type        = list(string)
  description = "List of packages to install via cloud-init."
  default     = ["docker.io", "docker-compose-plugin", "unattended-upgrades"]
}

variable "vm_web_serial_port_enabled" {
  type        = string
  default     = "0"
  description = "Enables serial port access for debugging and recovery (1 = enabled, 0 = disabled)."
}

variable "service_account_id" {
  type        = string
  description = ""
}



# DNS vars
variable "dns_zone_name" {
  type        = string
  description = "The name of the DNS zone to be created."
  default     = "my-private-zone"
}

variable "dns_zone_description" {
  type        = string
  description = "A description for the DNS zone."
  default     = "The project DNS setup"
}

variable "domain_zone" {
  type        = string
  description = "The DNS zone (FQDN) for the domain. Must end with a dot."
  default     = "awesome-devops-project-by-laura.com."
}

variable "dns_zone_public" {
  type        = bool
  description = "Indicates whether the DNS zone is public or private."
  default     = true
}

variable "dns_record_name" {
  type        = string
  description = "The name of the DNS recordset to be created (FQDN)."
  default     = "srv.awesome-devops-project-by-laura.com."
}

variable "dns_record_type" {
  type        = string
  description = "The type of the DNS record (e.g., 'A', 'CNAME', etc.)."
  default     = "A"
}

variable "dns_record_ttl" {
  type        = number
  description = "The Time-To-Live (TTL) for the DNS record, in seconds."
  default     = 200
}