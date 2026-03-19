resource "aws_iam_role" "ec2_s3_role" {
  name = "${local.name_prefix}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = var.iam_ec2_service
        }
      },
    ]
  })

  tags = {
    tag-key = "${local.name_prefix}-iam-role"
  }
}

resource "aws_iam_role_policy" "s3_write" {
  name = "${local.name_prefix}-s3-write-policy"
  role = aws_iam_role.ec2_s3_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = var.iam_s3_actions
        Resource = "${aws_s3_bucket.pb_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_s3_profile" {
  name = "${local.name_prefix}-profile"
  role = aws_iam_role.ec2_s3_role.name
}
