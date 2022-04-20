#tfsec:ignore:aws-s3-enable-bucket-encryption tfsec:ignore:aws-s3-enable-bucket-logging tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket" "bucket" {
  bucket = var.domain
}

resource "aws_s3_bucket_versioning" "bucket_version" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.template_file.init.rendered
}
resource "aws_s3_bucket_public_access_block" "bucket_pab" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# resource "aws_s3_object" "frontend" {
#   for_each = fileset("${path.module}/../../frontend/", "**")
#
#   bucket       = aws_s3_bucket.bucket.id
#   key          = each.value
#   source       = "${path.module}/../../frontend/${each.value}"
#   etag         = filemd5("${path.module}/../../frontend/${each.value}")
#   content_type = lookup(local.mime_types, regex("\\.[^.]+$", "${path.module}/../../frontend/${each.value}"), null)
# }

data "template_file" "init" {
  template = file("${path.module}/policy.tpl")
  vars = {
    domain     = var.domain
    cloudfront = aws_cloudfront_origin_access_identity.oai.id
  }
}

locals {
  mime_types = jsondecode(file("${path.module}/data/mime.json"))
}
