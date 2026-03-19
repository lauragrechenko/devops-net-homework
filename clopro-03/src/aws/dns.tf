resource "aws_route53_zone" "main" {
  name = local.route53_zone_name

  tags = {
    Environment = var.env
  }
}

resource "aws_route53_record" "website" {
  zone_id = aws_route53_zone.main.zone_id
  name    = local.website_fqdn
  type    = var.dns_record_type

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = var.dns_evaluate_target_health
  }
}
