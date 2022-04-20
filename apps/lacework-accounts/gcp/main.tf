terraform {
  required_providers {
    lacework = {
      source  = "lacework/lacework"
      version = "~> 0.16"
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

provider "google" {}

module "gcp_project_level_config" {
  source  = "lacework/config/gcp"
  version = "~> 1.0"
}

module "gcp_project_audit_log" {
  source                       = "lacework/audit-log/gcp"
  version                      = "~> 2.0"
  service_account_name         = module.gcp_project_level_config.service_account_name
  service_account_private_key  = module.gcp_project_level_config.service_account_private_key
  use_existing_service_account = true
  bucket_force_destroy         = true
}
