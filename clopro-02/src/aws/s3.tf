resource "aws_s3_bucket" "pb_bucket" {
  bucket = "${local.name_prefix}-bucket-${var.s3_bucket_suffix}"

  force_destroy = true

  tags = {
    Name        = "${local.name_prefix}-bucket"
    Environment = var.env
  }
}

resource "aws_s3_object" "pb_logo" {
  bucket       = aws_s3_bucket.pb_bucket.bucket
  key          = var.pb_logo_key
  source       = var.pb_logo_source
  content_type = var.pb_logo_content_type

  etag = filemd5(var.pb_logo_source)
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket     = aws_s3_bucket.pb_bucket.id
  policy     = data.aws_iam_policy_document.public_read.json
  depends_on = [aws_s3_bucket_public_access_block.pb_bucket]
}

data "aws_iam_policy_document" "public_read" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = ["${aws_s3_bucket.pb_bucket.arn}/${var.pb_logo_key}"]
  }
}

resource "aws_s3_bucket_public_access_block" "pb_bucket" {
  bucket = aws_s3_bucket.pb_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}