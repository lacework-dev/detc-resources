terraform {
  required_providers {
    lacework = {
      source  = "lacework/lacework"
      version = "1.17.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 4.4.0"
    }
  }
}

variable "lacework_account" {}
variable "lacework_subaccount" {}
variable "lacework_apikey" {}
variable "lacework_apisecret" {}

provider "lacework" {
  subaccount = var.lacework_subaccount
  account    = var.lacework_account
  api_key    = var.lacework_apikey
  api_secret = var.lacework_apisecret
}

module "gcp_project_level_config" {
  source  = "lacework/config/gcp"
  version = "2.4.3"
}

module "gcp_project_level_pub_sub_audit_log" {
  source           = "lacework/pub-sub-audit-log/gcp"
  version          = "0.4.0"
  integration_type = "PROJECT"
}
