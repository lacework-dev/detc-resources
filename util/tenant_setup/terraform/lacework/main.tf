terraform {
  required_providers {
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

resource "lacework_agent_access_token" "detc-agent-token" {
  name        = "detc-agent-token"
  description = "Agent token for use with DETC environments"
}

resource "lacework_query" "LW_Custom_UnrestrictedIngressToTCP3389" {
  query_id = "LW_Custom_UnrestrictedIngressToTCP3389"
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
          and rules:"properties".destinationPortRange = '3389'
          and rules:"properties".sourceAddressPrefix = '*'
      }
      return distinct {
          TENANT_ID,
          TENANT_NAME,
          SUBSCRIPTION_ID,
          SUBSCRIPTION_NAME,
          URN as RESOURCE_KEY,
          RESOURCE_REGION,
          RESOURCE_TYPE,
          RESOURCE_CONFIG
      }
    }
EOT
}

resource "lacework_policy" "LW_Policy_UnrestrictedIngressToTCP3389" {
  title       = "Security Groups Should Not Allow Unrestricted Ingress to TCP Port 3389"
  description = "Security Groups Should Not Allow Unrestricted Ingress to TCP Port 3389"
  remediation = "Investigate any suspicious activity."
  query_id    = lacework_query.LW_Custom_UnrestrictedIngressToTCP3389.id
  severity    = "High"
  type        = "Violation"
  evaluation  = "Hourly"
  enabled     = true

  alerting {
    enabled = true
    profile = "LW_CFG_AZURE_DEFAULT_PROFILE.Violation"
  }
}

output "agent-token" {
  value     = lacework_agent_access_token.detc-agent-token.token
  sensitive = true
}
