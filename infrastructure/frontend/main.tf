terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
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

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "access-identity-${var.domain}.s3.us-east-2.amazonaws.com"
}

#tfsec:ignore:aws-cloudfront-enable-logging
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = "${var.domain}.s3.us-east-2.amazonaws.com"
    origin_id   = "S3-${var.domain}"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.oai.id}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "public/index.html"
  price_class         = "PriceClass_100"
  aliases             = ["${var.domain}", "www.${var.domain}"]

  default_cache_behavior {
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id = "acba4595-bd28-49b8-b9fe-13317c0390fa"
    compress                 = true
    allowed_methods          = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = "S3-${var.domain}"


    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  logging_config {
    include_cookies = true
    bucket          = "rayprogramming-logs.s3.amazonaws.com"
    prefix          = "video.rayprogramming.com/cdn"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  tags = {
    Environment = "${var.domain}"
  }
  depends_on = [aws_acm_certificate_validation.ssl]
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.ssl.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  web_acl_id = aws_wafv2_web_acl.waf_acl.arn
}
