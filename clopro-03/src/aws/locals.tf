locals {
  name_prefix       = "${var.project}-${var.env}"
  website_fqdn      = "${var.subdomain}.${var.domain_name}"
  route53_zone_name = coalesce(var.route53_zone_name, var.domain_name)
  pb_logo_url       = "https://${aws_s3_bucket.pb_bucket.bucket}.s3.${var.default_region}.amazonaws.com/${aws_s3_object.pb_logo.key}"
}
