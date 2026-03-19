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

variable "s3_sse_algorithm" {
  type        = string
  default     = "AES256"
  description = " Server-side encryption algorithm to use."
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
  default     = 1
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

variable "alb_protocol" {
  type        = string
  default     = "HTTP"
  description = "Protocol for ALB target group and listener"
}

variable "alb_healthcheck" {
  type = object({
    path                = string
    healthy_threshold   = number
    unhealthy_threshold = number
    interval            = number
  })
  default = {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
  }
  description = "ALB health check configuration"
}

variable "asg_associate_public_ip" {
  type        = bool
  default     = false
  description = "Associate public IP to instances in ASG (false for private subnet)"
}

# S3 access

variable "s3_force_destroy" {
  type        = bool
  default     = true
  description = "Allow bucket deletion even if it contains objects"
}

variable "s3_block_public_access" {
  type        = bool
  default     = false
  description = "Block public access to S3 bucket (false to allow public logo)"
}

# IAM

variable "iam_ec2_service" {
  type        = string
  default     = "ec2.amazonaws.com"
  description = "AWS service principal for EC2 assume role"
}

variable "iam_s3_actions" {
  type        = list(string)
  default     = ["s3:PutObject", "s3:GetObject"]
  description = "S3 actions allowed for the EC2 IAM role"
}

# DNS
variable "domain_name" {
  type        = string
  default     = "openjar.xyz"
  description = "Root domain name for Route53 hosted zone"
}

variable "subdomain" {
  type        = string
  default     = "aws"
  description = "Subdomain for the website (e.g. aws → aws.openjar.xyz)"
}

variable "route53_zone_name" {
  type        = string
  default     = null
  description = "Hosted zone name managed in Route53. Leave null to manage the root domain zone, or set a delegated subdomain such as aws.example.com."
}

variable "dns_evaluate_target_health" {
  type        = bool
  default     = true
  description = "Whether Route53 should check ALB target health for DNS routing"
}

variable "dns_record_type" {
  type        = string
  default     = "A"
  description = "DNS record type for website alias"
}

variable "dns_ttl" {
  type        = number
  default     = 60
  description = "TTL for DNS validation records"
}

# SSL/HTTPS

variable "acm_validation_method" {
  type        = string
  default     = "DNS"
  description = "ACM certificate validation method. EMAIL requires manual approval before the HTTPS listener can finish creating."

  validation {
    condition     = contains(["DNS", "EMAIL"], var.acm_validation_method)
    error_message = "acm_validation_method must be either DNS or EMAIL."
  }
}

variable "https_port" {
  type        = number
  default     = 443
  description = "HTTPS port for ALB listener"
}

variable "alb_https_protocol" {
  type        = string
  default     = "HTTPS"
  description = "Protocol for HTTPS ALB listener"
}

variable "alb_ssl_policy" {
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
  description = "SSL policy for HTTPS ALB listener"
}
