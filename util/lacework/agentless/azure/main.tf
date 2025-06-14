terraform {
  required_providers {
    lacework = {
      source  = "lacework/lacework"
      version = "2.0.5"
    }
    command = {
      source = "hkak03key/command"
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

variable "azure_region" {
  description = "Azure region"
}

variable "azure_subscription_id" {
  description = "Azure subscription ID"
}

variable "azure_tenant_id" {
  description = "Azure tenant ID"
}

provider "lacework" {
  subaccount = var.lacework_subaccount
  account    = var.lacework_account
  api_key    = var.lacework_apikey
  api_secret = var.lacework_apisecret
}

module "lacework_azure_agentless_scanning_subscription" {
  source = "lacework/agentless-scanning/azure"

  integration_level              = "SUBSCRIPTION"
  global                         = true
  create_log_analytics_workspace = true
  region                         = var.azure_region
  scanning_subscription_id       = var.azure_subscription_id
  tenant_id                      = var.azure_tenant_id
  // specify which subscriptions to monitor - only do this in the global module
  included_subscriptions         = ["/subscriptions/${var.azure_subscription_id}"]

}