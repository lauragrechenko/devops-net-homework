variable "default_region" {
  type        = string
  default     = "eu-central-1"
  description = "AWS region for resource deployment"
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
}

variable "default_availability_zone" {
  type        = string
  default     = "eu-central-1a"
  description = "AWS availability zone for subnet placement"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.10.0.0/16"
  description = "CIDR block for the VPC"
}

variable "cidr_public" {
  type        = string
  default     = "10.10.1.0/24"
  description = "CIDR block for the public subnet"
}

variable "enable_dns_support" {
  type        = bool
  default     = true
  description = "Enable DNS support in the VPC"
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = true
  description = "Enable DNS hostnames in the VPC"
}

variable "map_public_ip_on_launch" {
  type        = bool
  default     = true
  description = "Auto-assign public IP to instances in public subnet"
}

variable "cidr_public_secondary" {
  type        = string
  default     = "10.10.3.0/24"
  description = "CIDR block for the second public subnet"
}

variable "cidr_public_tertiary" {
  type        = string
  default     = "10.10.4.0/24"
  description = "CIDR block for the third public subnet"
}

variable "availability_zone_secondary" {
  type        = string
  default     = "eu-central-1b"
  description = "Secondary availability zone"
}

variable "availability_zone_tertiary" {
  type        = string
  default     = "eu-central-1c"
  description = "Tertiary availability zone"
}

variable "cidr_private_secondary" {
  type        = string
  default     = "10.10.5.0/24"
  description = "CIDR block for the second private subnet"
}

variable "cidr_private" {
  type        = string
  default     = "10.10.2.0/24"
  description = "CIDR block for the private subnet"
}

variable "map_private_ip_on_launch" {
  type        = bool
  default     = false
  description = "Auto-assign public IP to instances in private subnet"
}


# RDS MySQL

variable "db_engine_version" {
  type        = string
  default     = "8.0"
  description = "MySQL engine version for RDS"
}

variable "db_instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "RDS instance class"
}

variable "db_allocated_storage" {
  type        = number
  default     = 20
  description = "Allocated storage in GB for RDS instance"
}

variable "db_storage_type" {
  type        = string
  default     = "gp2"
  description = "Storage type for RDS instance"
}

variable "db_name" {
  type        = string
  default     = "netology_db"
  description = "Name of the MySQL database"
}

variable "db_username" {
  type        = string
  default     = "admin"
  description = "Master username for RDS"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Master password for RDS"
}

variable "db_backup_retention" {
  type        = number
  default     = 1
  description = "Number of days to retain automated backups"
}

variable "db_multi_az" {
  type        = bool
  default     = true
  description = "Enable Multi-AZ deployment for RDS failover"
}

variable "db_skip_final_snapshot" {
  type        = bool
  default     = true
  description = "Skip final snapshot on RDS deletion (true for dev)"
}

variable "db_port" {
  type        = number
  default     = 3306
  description = "MySQL port for RDS"
}

# EKS

variable "eks_version" {
  type        = string
  default     = "1.31"
  description = "Kubernetes version for EKS cluster"
}

variable "eks_node_desired_size" {
  type        = number
  default     = 3
  description = "Desired number of EKS worker nodes"
}

variable "eks_node_max_size" {
  type        = number
  default     = 6
  description = "Maximum number of EKS worker nodes"
}

variable "eks_node_min_size" {
  type        = number
  default     = 3
  description = "Minimum number of EKS worker nodes"
}

variable "eks_node_max_unavailable" {
  type        = number
  default     = 1
  description = "Maximum number of unavailable nodes during update"
}

variable "eks_node_instance_type" {
  type        = string
  default     = "t3.small"
  description = "EC2 instance type for EKS worker nodes"
}

variable "eks_auth_mode" {
  type        = string
  default     = "API"
  description = "EKS cluster authentication mode (API, CONFIG_MAP, API_AND_CONFIG_MAP)"
}

variable "eks_cluster_service_principal" {
  type        = string
  default     = "eks.amazonaws.com"
  description = "AWS service principal for EKS cluster role"
}

variable "eks_node_service_principal" {
  type        = string
  default     = "ec2.amazonaws.com"
  description = "AWS service principal for EKS node group role"
}

variable "eks_cluster_policy_arn" {
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  description = "ARN of AmazonEKSClusterPolicy"
}

variable "eks_node_worker_policy_arn" {
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  description = "ARN of AmazonEKSWorkerNodePolicy"
}

variable "eks_node_cni_policy_arn" {
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  description = "ARN of AmazonEKS_CNI_Policy"
}

variable "eks_node_ecr_policy_arn" {
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  description = "ARN of AmazonEC2ContainerRegistryReadOnly"
}

# phpMyAdmin

variable "pma_secret_name" {
  type        = string
  default     = "mysql-creds"
  description = "Kubernetes secret name for MySQL credentials"
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
  description = "HTTP port for phpMyAdmin"
}

# EKS access

variable "eks_admin_principal_arn" {
  type        = string
  description = "IAM principal ARN for EKS cluster admin access"
}

variable "eks_admin_policy_arn" {
  type        = string
  default     = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  description = "EKS access policy ARN for cluster admin"
}
