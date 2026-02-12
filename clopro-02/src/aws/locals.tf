locals {
  name_prefix = "${var.project}-${var.env}"
  pb_logo_url = "https://${aws_s3_bucket.pb_bucket.bucket}.s3.${var.default_region}.amazonaws.com/${aws_s3_object.pb_logo.key}"

}