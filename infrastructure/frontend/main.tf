terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.7.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  alias  = "east-1"
}


resource "aws_s3_bucket" "bucket" {
  bucket = "${var.name}.${var.domain}"
  policy = data.template_file.init.rendered
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "arn"
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_object" "index" {
  bucket = "${var.name}.${var.domain}"
  key    = "index.html"
  source = "${path.module}/../../frontend/index.html"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = "${var.name}.${var.domain}.s3.us-east-2.amazonaws.com"
    origin_id   = "S3-${var.name}.${var.domain}"
  }
  minimum_protocol_version = "TLSv1.2_2021"
  enabled                  = true
  is_ipv6_enabled          = true
  default_root_object      = "index.html"
  price_class              = "PriceClass_100"
  aliases                  = ["${var.name}.${var.domain}", "www.${var.name}.${var.domain}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${var.name}.${var.domain}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "${var.name}.${var.domain}"
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.ssl.arn
    ssl_support_method  = "sni-only"
  }

  depends_on = [aws_acm_certificate_validation.ssl]

  web_acl_id = aws_wafv2_web_acl.waf_acl.id
}

data "template_file" "init" {
  template = file("${path.module}/policy.tpl")
  vars = {
    name       = var.name
    domain     = var.domain
    cloudfront = aws_cloudfront_distribution.s3_distribution.id
  }
}
