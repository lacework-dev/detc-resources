terraform {
  required_providers {
    lacework = {
      source  = "lacework/lacework"
      version = "2.0.5"
    }
    google = {
      source  = "hashicorp/google"
      version = "5.39.1"
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
}

module "gcp_project_level_pub_sub_audit_log" {
  source           = "lacework/pub-sub-audit-log/gcp"
  integration_type = "PROJECT"
}
