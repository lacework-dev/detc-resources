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

resource "lacework_query" "LW_Custom_BashCommands" {
  query_id = "LW_Custom_BashCommands"
  query    = <<EOT
  {
      source {
          LW_HA_SYSCALLS_EXEC
      }
      filter {
            (
            KERNEL_COMMAND = 'sudo'
            OR KERNEL_COMMAND = 'apk'
            OR KERNEL_COMMAND = 'apt'
            OR KERNEL_COMMAND = 'apt-get'
            OR KERNEL_COMMAND = 'echo'
            OR KERNEL_COMMAND = 'strace'
            OR KERNEL_COMMAND = 'chmod'
            OR KERNEL_COMMAND = 'scp'
            OR KERNEL_COMMAND = 'export'
            OR KERNEL_COMMAND = 'ln')
      }
      return distinct {
            RECORD_CREATED_TIME,
            MID,
            PID_HASH,
            EXE_PATH,
            PARENT_EXE_PATH,
            CMDLINE
      }
  }
EOT
}

resource "lacework_policy" "LW_Custom_Bash_Command_Policy" {
  title       = "Bash Command Run on Host"
  description = "Alert contains details on a bash command caught by Lacework agent syscall detections."
  remediation = "Collect this and similair alerts for investigation and retro session"
  query_id    = lacework_query.LW_Custom_BashCommands.id
  severity    = "High"
  type        = "Violation"
  evaluation  = "Hourly"
  enabled     = true

  alerting {
    enabled = true
    profile = "LW_HA_SYSCALLS_EXEC_DEFAULT_PROFILE.Violation"
  }
}