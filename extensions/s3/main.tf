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

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership_control" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
  depends_on = [
    aws_s3_bucket_public_access_block.bucket,
    aws_s3_bucket_ownership_controls.bucket_ownership_control,
  ]
}

output "bucket_name" {
  value = local.bucket_name
}
