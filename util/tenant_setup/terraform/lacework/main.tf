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

resource "lacework_query" "LW_Custom_ReverseShellConnection" {
  query_id = "LW_Custom_ReverseShellConnection"
  query    = <<EOT
  {
    source {
        LW_HE_PROCESSES
    }
    filter {
        EXE_PATH like any(
            '%/sh',
            '%/bash',
            '%/zsh',
            '%/csh',
            '%/ksh',
            '%/ash',
            '%/bsh',
            '%/pdksh',
            '%/tcsh',
            '%/dash')
        and CMDLINE like any(
            'bash -i',
            '%/bash -i',
            '%/bash -i %',
            '% bash -i %',
            'sh -i',
            '%/sh -i',
            '%/sh -i %',
            '% sh -i %',
            'zsh -i',
            '%/zsh -i',
            '%/zsh -i %',
            '% zsh -i %',
            'csh -i',
            '%/csh -i',
            '%/csh -i %',
            '% csh -i %',
            'ksh -i',
            '%/ksh -i',
            '%/ksh -i %',
            '% ksh -i %',
            'tcsh -i',
            '%/tcsh -i',
            '%/tcsh -i %',
            '% tcsh -i %',
            'ash -i',
            '%/ash -i',
            '%/ash -i %',
            '% ash -i %',
            'pdksh -i',
            '%/pdksh -i',
            '%/pdksh -i %',
            '% pdksh -i %',
            'bsh -i',
            '%/bsh -i',
            '%/bsh -i %',
            '% bsh -i %',
            'dash -i',
            '%/dash -i',
            '%/dash -i %',
            '% dash -i %')
    }
    return distinct {
        PROCESS_START_TIME,
        MID,
        USERNAME,
        EXE_PATH,
        CWD,
        PID_HASH,
        CMDLINE
    }
  }
EOT
}

resource "lacework_policy" "LW_Custom_ReverseShellConnection" {
  title       = "Reverse Shell Connection Found"
  description = "Reverse Shell Connection Found"
  remediation = "Investigate any suspicious activity."
  query_id    = lacework_query.LW_Custom_ReverseShellConnection.id
  severity    = "Critical"
  type        = "Violation"
  evaluation  = "Hourly"
  enabled     = true

  alerting {
    enabled = true
    profile = "LW_HE_PROCESSES_DEFAULT_PROFILE.HE_Process_Violation"
  }
}

output "agent-token" {
  value     = lacework_agent_access_token.detc-agent-token.token
  sensitive = true
}
