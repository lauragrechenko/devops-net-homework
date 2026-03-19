locals {
  name_prefix  = "${var.project}-${var.env}"
  website_fqdn = "${var.website_subdomain}.${var.domain_name}"
  website_url  = "https://${local.website_fqdn}"
}
