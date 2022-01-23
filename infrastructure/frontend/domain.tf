resource "aws_route53_record" "subdomain-www" {
  zone_id = var.zoneid
  name    = "www.${var.name}"
  type    = "A"
  count   = var.subdomain

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "subdomain-root" {
  zone_id = var.zoneid
  name    = var.name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_acm_certificate" "ssl" {
  domain_name               = "${var.name}.${var.domain}"
  subject_alternative_names = ["www.${var.name}.${var.domain}"]
  validation_method         = "DNS"

  tags = {
    site = var.domain
  }
}

resource "aws_acm_certificate_validation" "ssl" {
  certificate_arn = aws_acm_certificate.ssl.arn
}
