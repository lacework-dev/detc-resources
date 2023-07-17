variable "aggregate_findings" {
  default = false
}

variable "region" {}

provider "aws" {
  region = var.region
}

resource "aws_securityhub_account" "main" {}

resource "aws_securityhub_standards_subscription" "cis_aws_foundations_benchmark" {
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
  depends_on    = [aws_securityhub_account.main]
}

resource "aws_securityhub_finding_aggregator" "main" {
  count        = var.aggregate_findings ? 1 : 0
  linking_mode = "ALL_REGIONS"

  depends_on = [aws_securityhub_account.main]
}
