resource "aws_iam_role" "iam_for_lambda" { //Switch to data struct or remote_state
  name               = "iam_for_lambda"
  path               = "/${var.project}/${var.env}/${local.module_name}/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
