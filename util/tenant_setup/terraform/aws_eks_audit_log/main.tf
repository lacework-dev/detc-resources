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
variable "cluster_name" {}
variable "cluster_region" {}
variable "lacework_aws_account_id" {
  default = "434813966438"
}

provider "lacework" {
  subaccount = var.lacework_subaccount
  account    = var.lacework_account
  api_key    = var.lacework_apikey
  api_secret = var.lacework_apisecret
}

provider "aws" {
  version = "5.60.0"
}

module "aws_eks_audit_log" {
  lacework_aws_account_id = format("%d", var.lacework_aws_account_id)
  source                  = "lacework/eks-audit-log/aws"
  version                 = "1.1.6"
  cloudwatch_regions      = [var.cluster_region]
  cluster_names           = [var.cluster_name]
  bucket_force_destroy    = true
}
