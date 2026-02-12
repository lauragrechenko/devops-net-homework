# output "alb_dns_name" {
#   description = ""
#   value       = ""
# }

output "pb_logo_url" {
  value = local.pb_logo_url
}

output "nlb_dns_name" {
  value = aws_lb.nlb.dns_name
}