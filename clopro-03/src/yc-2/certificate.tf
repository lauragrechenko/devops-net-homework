resource "yandex_cm_certificate" "website_cert" {
  name    = "${local.name_prefix}-website-cert"
  domains = ["${var.website_subdomain}.${var.domain_name}"]

  managed {
    challenge_type = "DNS_CNAME"
  }
}
