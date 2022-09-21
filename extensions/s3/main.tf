variable "region" {}
variable "partial_bucket_name" {
  type = string
}

resource "random_integer" "ri" {
  min = 100000
  max = 999999
}

locals {
  bucket_name = "${var.partial_bucket_name}-${random_integer.ri.result}"
}

provider "aws" {}

resource "aws_s3_bucket" "bucket" {
  bucket = local.bucket_name
  tags = {
    Name        = local.bucket_name
    Environment = "Production"
  }
  force_destroy = true
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

output "bucket_name" {
  value = local.bucket_name
}
