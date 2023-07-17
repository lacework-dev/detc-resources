### https://aws.amazon.com/blogs/mt/how-to-deploy-aws-config-conformance-packs-using-terraform/
variable "region" {}

variable "aggregate_findings" {
  default = false
}

variable "encryption_enabled" {
  type        = bool
  default     = true
  description = "When set to 'true' the resource will have AES256 encryption enabled by default"
}

provider "aws" {
  region = var.region
}

resource "random_integer" "ri" {
  min = 100000
  max = 999999
}

locals {
  bucket_name = "awsconfig-bucket-${random_integer.ri.result}"
  role_name   = "awsconfig-role-${random_integer.ri.result}"
}
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

resource "aws_iam_role" "config_role" {
  name = local.role_name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "config_policy_attach" {
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

resource "aws_iam_role_policy_attachment" "read_only_policy_attach" {
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_config_configuration_recorder" "config_recorder" {

  name     = "config_recorder"
  role_arn = aws_iam_role.config_role.arn
  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_s3_bucket" "new_config_bucket" {
  bucket        = local.bucket_name
  acl           = "private"
  force_destroy = true
  dynamic "server_side_encryption_configuration" {
    for_each = var.encryption_enabled ? ["true"] : []

    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = "AES256"
        }
      }
    }
  }
}

resource "aws_s3_bucket_policy" "config_logging_policy" {
  bucket = aws_s3_bucket.new_config_bucket.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowBucketAcl",
      "Effect": "Allow",
      "Principal": {
        "Service": [
         "config.amazonaws.com"
        ]
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "${aws_s3_bucket.new_config_bucket.arn}",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "true"
        }
      }
    },
    {
      "Sid": "AllowConfigWriteAccess",
      "Effect": "Allow",
      "Principal": {
        "Service": [
         "config.amazonaws.com"
        ]
      },
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.new_config_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/Config/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        },
        "Bool": {
          "aws:SecureTransport": "true"
        }
      }
    },
    {
      "Sid": "RequireSSL",
      "Effect": "Deny",
      "Principal": {
        "AWS": "*"
      },
      "Action": "s3:*",
      "Resource": "${aws_s3_bucket.new_config_bucket.arn}/*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_config_configuration_aggregator" "account" {
  name  = "aggregator-${data.aws_caller_identity.current.account_id}"
  count = var.aggregate_findings ? 1 : 0

  account_aggregation_source {
    account_ids = [data.aws_caller_identity.current.account_id]
    regions     = ["us-east-1", "us-east-2", "us-west-1", "us-west-2"]
  }
}

resource "aws_config_delivery_channel" "config_channel" {
  s3_bucket_name = aws_s3_bucket.new_config_bucket.id
  depends_on     = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_config_configuration_recorder_status" "config_recorder_status" {
  name       = aws_config_configuration_recorder.config_recorder.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.config_channel]
}
