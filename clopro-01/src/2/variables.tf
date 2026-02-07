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
  default     = "192.168.0.0/16"
  description = "CIDR block for the VPC"
}

variable "cidr_public" {
  type        = string
  default     = "192.168.10.0/24"
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

variable "cidr_private" {
  type        = string
  default     = "192.168.20.0/24"
  description = "CIDR block for the private subnet"
}

variable "map_private_ip_on_launch" {
  type        = bool
  default     = false
  description = "Auto-assign public IP to instances in private subnet"
}

variable "ssh_port" {
  type        = number
  default     = 22
  description = "SSH port for security group ingress rule"
}

variable "my_ip_url" {
  type        = string
  default     = "https://checkip.amazonaws.com/"
  description = "URL to detect current public IP for SSH access restriction"
}

# SSH
variable "ssh_pub_key_path" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "Path to SSH public key file"
}

# AMI lookup
variable "ami_owner" {
  type        = string
  default     = "099720109477"
  description = "AWS account ID of the AMI owner (099720109477 = Canonical)"
}

variable "ami_name_filter" {
  type        = string
  default     = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
  description = "Name filter pattern for AMI lookup"
}

variable "ami_architecture" {
  type        = string
  default     = "x86_64"
  description = "CPU architecture filter for AMI lookup"
}

# Public VM
variable "vm_public_instance_type" {
  type        = string
  default     = "t3.micro"
  description = "Instance type for public EC2 instance"
}

variable "vm_public_volume_type" {
  type        = string
  default     = "gp3"
  description = "Root volume type for public EC2 instance"
}

variable "vm_public_volume_size" {
  type        = number
  default     = 10
  description = "Root volume size in GB for public EC2 instance"
}

# Private VM
variable "vm_private_instance_type" {
  type        = string
  default     = "t3.micro"
  description = "Instance type for private EC2 instance"
}

variable "vm_private_volume_type" {
  type        = string
  default     = "gp3"
  description = "Root volume type for private EC2 instance"
}

variable "vm_private_volume_size" {
  type        = number
  default     = 10
  description = "Root volume size in GB for private EC2 instance"
}
