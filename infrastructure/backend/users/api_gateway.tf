resource "aws_apigatewayv2_api" "api" {
  name          = "${var.project}-${local.module_name}-${var.env}"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_domain_name" "domain" {
  domain_name = "${local.module_name}.${data.aws_route53_zone.selected.name}"

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.user_ssl.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id = aws_apigatewayv2_api.api.id
  name   = var.env
}

resource "aws_apigatewayv2_integration" "register" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"

  connection_type    = "INTERNET"
  description        = "Lambda example"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.register.invoke_arn
}

resource "aws_apigatewayv2_route" "register" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /register"

  target = "integrations/${aws_apigatewayv2_integration.register.id}"
}
