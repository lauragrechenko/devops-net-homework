output "nameservers" {
  value       = aws_route53_zone.main.name_servers
  description = "NS servers to delegate at the registrar or parent DNS zone"
}

output "route53_zone_name" {
  value       = aws_route53_zone.main.name
  description = "Hosted zone name managed in Route53"
}

output "alb_dns_name" {
  value       = aws_lb.alb.dns_name
  description = "ALB DNS name"
}

output "website_url" {
  value       = "https://${local.website_fqdn}"
  description = "Website URL with HTTPS"
}

output "certificate_arn" {
  value       = aws_acm_certificate.website.arn
  description = "ACM certificate ARN"
}

output "acm_dns_validation_records" {
  value = {
    for domain, record in aws_route53_record.cert_validation : domain => {
      name  = record.name
      type  = record.type
      value = one(record.records)
    }
  }
  description = "DNS validation records created for ACM when DNS validation is enabled"
}

output "s3_bucket_name" {
  value       = aws_s3_bucket.pb_bucket.bucket
  description = "S3 bucket name"
}

output "iam_role_name" {
  value       = aws_iam_role.ec2_s3_role.name
  description = "IAM role for EC2 S3 access"
}
