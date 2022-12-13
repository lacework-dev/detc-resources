terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.31"
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
variable "port" {}

provider "lacework" {
  subaccount = var.lacework_subaccount
  account    = var.lacework_account
  api_key    = var.lacework_apikey
  api_secret = var.lacework_apisecret
}

resource "lacework_query" "LQL_OPEN_PORT_QUERYs" {
  query_id = "TF_LQL_OPEN_PORT_QUERYs_${var.port}"
  query    = <<EOT
  {
      source {
          LW_CFG_AZURE_NETWORK_NETWORKSECURITYGROUPS a,
          array_to_rows(a.RESOURCE_CONFIG:securityRules) as (rules)
      }
      filter {
          rules:"properties".access = 'Allow'
          and rules:"properties".direction = 'Inbound'
          and rules:"properties".protocol = '*'
          and rules:"properties".destinationPortRange = ${var.port}
          and rules:"properties".sourceAddressPrefix = '*'
       }
      return distinct {
          TENANT_ID,
          TENANT_NAME,
          SUBSCRIPTION_ID,
          SUBSCRIPTION_NAME,
          URN as RESOURCE_KEY,
          RESOURCE_REGION,
          RESOURCE_TYPE
      }
  }
EOT
}

resource "lacework_policy" "LW_OPEN_PORT_POLICY" {
  title       = "Security Groups Should Not Allow Unrestricted Ingress to TCP Port ${var.port}"
  description = "Security groups should not allow unrestricted ingress to TCP port ${var.port}"
  remediation = "Login into Azure and update the security group to remove port ${var.port} from public access"
  query_id    = lacework_query.LQL_OPEN_PORT_QUERYs.id
  severity    = "High"
  type        = "Violation"
  evaluation  = "Hourly"
  enabled     = true

  alerting {
    enabled = true
    profile = "LW_CFG_AZURE_DEFAULT_PROFILE.Violation"
  }
}