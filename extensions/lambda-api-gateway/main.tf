variable "region" {}
variable "bucket_name" {}
variable "lambda_name" {}
variable "api_endpoint_name" {}
variable "lambda_runtime" {}
variable "lambda_handler" {}
variable "vpc_id" {}
variable "subnet_0" {}
variable "subnet_1" {}

variable "tags" {
  type = map(string)
  default = {}
}

provider "aws" {}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.lambda_name}-role"
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

resource "aws_iam_role_policy_attachment" "admin" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
  name        = "${var.lambda_name}-policy"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   },
   {
     "Sid": "Stmt1468366974000",
     "Effect": "Allow",
     "Action": "s3:*",
     "Resource": [ "arn:aws:s3:::${var.bucket_name}/*" ]
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "lambda"
  output_path = "lambda.zip"
}

resource "aws_default_security_group" "lambda_security_group" {
  vpc_id = var.vpc_id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ "Name" =  "${var.lambda_name}-security-group" }, var.tags)
}

resource "aws_lambda_function" "lambda_func" {
  filename      = "lambda.zip"
  function_name = var.lambda_name
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  role          = aws_iam_role.lambda_role.arn
  environment {
    variables = {
      BUCKET_NAME = var.bucket_name
    }
  }

  vpc_config {
    subnet_ids         = [var.subnet_0, var.subnet_1]
    security_group_ids = [aws_default_security_group.lambda_security_group.id]
  }
}

resource "aws_api_gateway_rest_api" "api_lambda" {
  name = "lambda-api-gateway"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api_lambda.id
  parent_id   = aws_api_gateway_rest_api.api_lambda.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_lambda.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_gateway_integration_lambda" {
  rest_api_id = aws_api_gateway_rest_api.api_lambda.id
  resource_id = aws_api_gateway_method.proxy_method.resource_id
  http_method = aws_api_gateway_method.proxy_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_func.invoke_arn
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.api_lambda.id
  resource_id   = aws_api_gateway_rest_api.api_lambda.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_gateway_integration_lambda_root" {
  rest_api_id = aws_api_gateway_rest_api.api_lambda.id
  resource_id = aws_api_gateway_method.proxy_root.resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_func.invoke_arn
}

resource "aws_api_gateway_deployment" "apideploy" {
  depends_on = [
    aws_api_gateway_integration.api_gateway_integration_lambda,
    aws_api_gateway_integration.api_gateway_integration_lambda_root,
  ]

  rest_api_id = aws_api_gateway_rest_api.api_lambda.id
  stage_name  = var.api_endpoint_name
}

resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_func.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.api_lambda.execution_arn}/*/*"
}

output "lambda_invoke_url" {
  value = aws_api_gateway_deployment.apideploy.invoke_url
}
