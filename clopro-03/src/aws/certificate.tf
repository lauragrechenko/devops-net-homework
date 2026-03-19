resource "aws_acm_certificate" "website" {
  domain_name       = local.website_fqdn
  validation_method = var.acm_validation_method

  tags = {
    Name        = "${local.name_prefix}-cert"
    Environment = var.env
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = var.acm_validation_method == "DNS" ? {
    for dvo in aws_acm_certificate.website.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  zone_id = aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = var.dns_ttl
  records = [each.value.record]

  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "website" {
  certificate_arn         = aws_acm_certificate.website.arn
  validation_record_fqdns = var.acm_validation_method == "DNS" ? [for record in aws_route53_record.cert_validation : record.fqdn] : null
}
