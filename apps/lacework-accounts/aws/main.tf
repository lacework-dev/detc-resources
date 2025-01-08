terraform {
  required_providers {
    lacework = {
      source  = "lacework/lacework"
      version = "2.0.5"
    }
  }
}

variable "lacework_account" {}
variable "lacework_subaccount" {}
variable "lacework_apikey" {}
variable "lacework_apisecret" {}
variable "lacework_aws_account_id" {
  default = "434813966438"
}

provider "lacework" {
  subaccount = var.lacework_subaccount
  account    = var.lacework_account
  api_key    = var.lacework_apikey
  api_secret = var.lacework_apisecret
}

provider "aws" {}

module "aws_config" {
  source                  = "lacework/config/aws"
  version                 = "0.18.0"
  lacework_aws_account_id = format("%d", var.lacework_aws_account_id)
}

module "main_cloudtrail" {
  cloudtrail_name         = "cloudtrail${var.lacework_account}${var.lacework_subaccount}"
  source                  = "lacework/cloudtrail/aws"
  version                 = "2.10.2"
  iam_role_arn            = module.aws_config.iam_role_arn
  iam_role_external_id    = module.aws_config.external_id
  iam_role_name           = module.aws_config.iam_role_name
  lacework_aws_account_id = format("%d", var.lacework_aws_account_id)
  use_existing_iam_role   = true
  bucket_force_destroy    = true
}
