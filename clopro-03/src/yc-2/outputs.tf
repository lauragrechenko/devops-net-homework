output "website_url" {
  value       = local.website_url
  description = "Static website URL"
}

output "bucket_name" {
  value       = yandex_storage_bucket.pb_bucket.bucket
  description = "S3 bucket name"
}

output "certificate_id" {
  value       = yandex_cm_certificate.website_cert.id
  description = "Certificate Manager certificate ID"
}

output "cert_validation_records" {
  value       = yandex_cm_certificate.website_cert.challenges
  description = "DNS records to add at the domain registrar for cert validation"
}
