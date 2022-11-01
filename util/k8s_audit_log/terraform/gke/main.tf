terraform {
  required_providers {
    lacework = {
      source  = "lacework/lacework"
      version = "~> 0.26"
    }
    google = {
      source  = "hashicorp/google"
      version = "4.41.0"
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

module "gcp_project_level_gke_audit_log" {
  source           = "lacework/gke-audit-log/gcp"
  version          = "~> 0.3"
  integration_type = "PROJECT"
}
