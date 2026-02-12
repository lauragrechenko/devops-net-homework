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

variable "cidr_public_2" {
  type        = string
  default     = "10.10.3.0/24"
  description = "CIDR block for the second public subnet (ALB requires 2 AZs)"
}

variable "availability_zone_2" {
  type        = string
  default     = "eu-central-1b"
  description = "Secondary availability zone for ALB"
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

# S3

variable "s3_bucket_suffix" {
  type        = string
  default     = "laura-10-02-26"
  description = "Unique suffix for S3 bucket name"
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
  description = "Content-Type for the logo file in S3"
}

#  ASG

variable "asg_size" {
  type        = number
  default     = 3
  description = "Number of EC2 instances in ASG"
}

variable "asg_instance_type" {
  type        = string
  default     = "t3.micro"
  description = "EC2 instance type for ASG"
}

variable "asg_volume_size" {
  type        = number
  default     = 10
  description = "Root volume size in GB for ASG instances"
}

variable "asg_volume_type" {
  type        = string
  default     = "gp3"
  description = "Root volume type for ASG instances"
}

variable "asg_root_device" {
  type        = string
  default     = "/dev/sda1"
  description = "Root device name for ASG instances"
}

# NLB

variable "web_port" {
  type        = number
  default     = 80
  description = "HTTP port for web traffic"
}

variable "nlb_healthcheck" {
  type = object({
    healthy_threshold   = number
    unhealthy_threshold = number
    interval            = number
  })
  default = {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
  }
  description = "NLB health check configuration"
}

variable "alb_healthcheck" {
  type = object({
    healthy_threshold   = number
    unhealthy_threshold = number
    interval            = number
  })
  default = {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
  }
  description = "ALB health check configuration"
}
