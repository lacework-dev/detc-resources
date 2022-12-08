terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.31"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.91.0"
    }
    lacework = {
      source  = "lacework/lacework"
      version = "1.0.1"
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

provider "azuread" {
}

provider "azurerm" {
  features {
  }
}

module "az_ad_application" {
  source  = "lacework/ad-application/azure"
  version = "1.2.1"
}

module "az_config" {
  source                      = "lacework/config/azure"
  version                     = "1.1.1"
  application_id              = module.az_ad_application.application_id
  application_password        = module.az_ad_application.application_password
  service_principal_id        = module.az_ad_application.service_principal_id
  use_existing_ad_application = true
}

module "az_activity_log" {
  source                      = "lacework/activity-log/azure"
  version                     = "1.2.1"
  application_id              = module.az_ad_application.application_id
  application_password        = module.az_ad_application.application_password
  service_principal_id        = module.az_ad_application.service_principal_id
  use_existing_ad_application = true
}
