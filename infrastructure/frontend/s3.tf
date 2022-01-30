#tfsec:ignore:aws-s3-enable-bucket-encryption tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.name}.${var.domain}"
  policy = data.template_file.init.rendered
  acl    = "private"

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
