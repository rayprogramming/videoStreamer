resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy = jsonencode(
    {
      Id      = "key-default-1"
      Version = "2012-10-17"
      Statement = [
        {
          Action = "kms:*"
          Effect = "Allow"
          Principal = {
            AWS = [
              "arn:aws:sts::529080338478:assumed-role/video_plan/gh",
              "arn:aws:iam::529080338478:root",
            ]
          }
          Resource = "*"
          Sid      = "Enable IAM User Permissions"
        },
      ]
    }
  )
}

#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.name}.${var.domain}"
  policy = data.template_file.init.rendered
  acl    = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_pab" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_object" "frontend" {
  for_each = fileset("${path.module}/../../frontend/", "*")

  bucket = aws_s3_bucket.bucket.id
  key    = each.value
  source = "${path.module}/../../frontend/${each.value}"
  etag   = filemd5("${path.module}/../../frontend/${each.value}")
}

data "template_file" "init" {
  template = file("${path.module}/policy.tpl")
  vars = {
    name       = var.name
    domain     = var.domain
    cloudfront = aws_cloudfront_origin_access_identity.oai.id
  }
}
