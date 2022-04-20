resource "aws_acm_certificate" "ssl" {
  provider          = aws.east-1
  domain_name       = "auth.${data.aws_route53_zone.selected.name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "user_ssl" {
  provider          = aws.east-1
  domain_name       = "${local.module_name}.${data.aws_route53_zone.selected.name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
