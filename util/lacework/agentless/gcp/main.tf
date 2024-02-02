terraform {
  required_providers {
    lacework = {
      source  = "lacework/lacework"
      version = "1.18.0"
    }
  }
}

variable "lacework_account" {}
variable "lacework_subaccount" {}
variable "lacework_apikey" {}
variable "lacework_apisecret" {}
variable "gcp_project_filter_list" {
  description = "csv of expected projects to include"
}

provider "lacework" {
  subaccount = var.lacework_subaccount
  account    = var.lacework_account
  api_key    = var.lacework_apikey
  api_secret = var.lacework_apisecret
}


provider "google" {
  alias  = "use1"
  region = "us-east1"
}
provider "google" {
  alias  = "use4"
  region = "us-east4"
}
provider "google" {
  alias  = "usc1"
  region = "us-central1"
}
provider "google" {
  alias  = "usw1"
  region = "us-west1"
}
provider "google" {
  alias  = "usw2"
  region = "us-west2"
}

locals {
  gcp_proj_filter = split(",", var.gcp_project_filter_list)
}

module "lacework_gcp_agentless_scanning_project_multi_region_use1" {
  source  = "lacework/agentless-scanning/gcp"
  version = "~> 0.1"

  providers = {
    google = google.use1
  }

  project_filter_list       = local.gcp_proj_filter
  global                    = true
  regional                  = true
  lacework_integration_name = "agentless_from_terraform"
}

module "lacework_gcp_agentless_scanning_project_multi_region_usc1" {
  source  = "lacework/agentless-scanning/gcp"
  version = "~> 0.1"

  providers = {
    google = google.usc1
  }

  project_filter_list     = local.gcp_proj_filter
  regional                = true
  global_module_reference = module.lacework_gcp_agentless_scanning_project_multi_region_use1
}

module "lacework_gcp_agentless_scanning_project_multi_region_use4" {
  source  = "lacework/agentless-scanning/gcp"
  version = "~> 0.1"

  providers = {
    google = google.use4
  }

  project_filter_list     = local.gcp_proj_filter
  regional                = true
  global_module_reference = module.lacework_gcp_agentless_scanning_project_multi_region_use1
}

module "lacework_gcp_agentless_scanning_project_multi_region_usw1" {
  source  = "lacework/agentless-scanning/gcp"
  version = "~> 0.1"

  providers = {
    google = google.usw1
  }

  project_filter_list     = local.gcp_proj_filter
  regional                = true
  global_module_reference = module.lacework_gcp_agentless_scanning_project_multi_region_use1
}
