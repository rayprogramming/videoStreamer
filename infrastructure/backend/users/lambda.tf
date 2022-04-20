resource "aws_lambda_function" "register" {
  filename         = data.archive_file.register.output_path
  function_name    = "${local.module_name}_register"
  role             = data.terraform_remote_state.iam.outputs.video_users_lambda.arn
  handler          = "register.handler"
  source_code_hash = data.archive_file.register.output_base64sha256
  runtime          = "nodejs14.x"

  environment {
    variables = {
      CLIENT_ID     = aws_cognito_user_pool_client.client.id
      POOL_ID       = aws_cognito_user_pool.user_pool.id
      CLIENT_SECRET = aws_cognito_user_pool_client.client.client_secret
    }
  }
}

data "archive_file" "register" {
  type        = "zip"
  source_file = "${path.module}/functions/dist/register.js"
  output_path = "${path.module}/${local.module_name}_register.zip"
}

resource "aws_lambda_function" "confirm_register" {
  filename         = data.archive_file.confirm_register.output_path
  function_name    = "${local.module_name}_confirm_register"
  role             = data.terraform_remote_state.iam.outputs.video_users_lambda.arn
  handler          = "confirm_register.handler"
  source_code_hash = data.archive_file.confirm_register.output_base64sha256
  runtime          = "nodejs14.x"

  environment {
    variables = {
      CLIENT_ID     = aws_cognito_user_pool_client.client.id
      POOL_ID       = aws_cognito_user_pool.user_pool.id
      CLIENT_SECRET = aws_cognito_user_pool_client.client.client_secret
    }
  }
}

data "archive_file" "confirm_register" {
  type        = "zip"
  source_file = "${path.module}/functions/dist/confirmRegistration.js"
  output_path = "${path.module}/${local.module_name}_confirmRegister.zip"
}
