variable "registry_name" {}

variable "tags" {
  type = map(string)
  default = {}
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.24.0"
    }
  }
}

resource "aws_ecr_repository" "registry" {
  name                 = var.registry_name
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}

resource "aws_iam_user" "ecr_registry_user" {
  name = "${var.registry_name}_acces_user"
  path = "/system/ecr/"
}

resource "aws_iam_access_key" "ecr_registry_user_key" {
  user = aws_iam_user.ecr_registry_user.name
}

resource "aws_iam_role" "registry_access_role" {
  name = "${var.registry_name}-role"
  managed_policy_arns = [
    aws_iam_policy.registry_access_policy.arn
  ]
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_user.ecr_registry_user.arn}"
      },
      "Action": [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["ec2.amazonaws.com", "ecs.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_policy" "registry_access_policy" {
  name = "${var.registry_name}-ecr-access-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Effect   = "Allow"
        Resource = "*"

      },
      {
        Action = [
          "ecr:*"
        ]
        Effect   = "Allow"
        Resource = "${aws_ecr_repository.registry.arn}*"
      },
    ]
  })
}

output "access_iam_role" {
  value = aws_iam_role.registry_access_role.arn
}

output "access_iam_policy" {
  value = aws_iam_policy.registry_access_policy.arn
}

output "registry_id" {
  value = aws_ecr_repository.registry.id
}

output "registry_arn" {
  value = aws_ecr_repository.registry.arn
}

output "registry_name" {
  value = aws_ecr_repository.registry.name
}

output "registry_url" {
  value = aws_ecr_repository.registry.repository_url
}

output "ecr_access_user_access_key" {
  sensitive = true
  value     = aws_iam_access_key.ecr_registry_user_key.id
}

output "ecr_access_user_secret_key" {
  sensitive = true
  value     = aws_iam_access_key.ecr_registry_user_key.secret
}
