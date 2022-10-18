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

resource "lacework_agent_access_token" "detc-agent-token" {
  name        = "detc-agent-token"
  description = "Agent token for use with DETC environments"
}

resource "lacework_query" "DETC_PotentialReverseShell_Query" {
  query_id = "DETC_PotentialReverseShell_Query"
  query    = <<EOT
    {
        source {
            LW_HE_PROCESSES
        }
        filter {
            (
                ((RIGHT(EXE_PATH, 3) = '/sh'
                    or RIGHT(EXE_PATH, 4) = '/ash'
                    or RIGHT(EXE_PATH, 5) = '/bash'
                    or RIGHT(EXE_PATH, 5) = '/dash')
                    and not CONTAINS(CMDLINE, '.vscode-server')
                    and not CONTAINS(CMDLINE, 'ssh -i')
                    and (CMDLINE = 'sh -i'
                        or LEFT(CMDLINE, 6) = 'sh -i '
                        or CONTAINS(CMDLINE, '/sh -i ')
                        or RIGHT(CMDLINE, 6) = '/sh -i'
                        or CMDLINE = 'bash -i'
                        or LEFT(CMDLINE, 8) = 'bash -i '
                        or CONTAINS(CMDLINE, '/bash -i ')
                        or RIGHT(CMDLINE, 8) = '/bash -i')
                )
                or (RIGHT(EXE_PATH, 3) = '/nc' and CONTAINS(CMDLINE, ' -e'))
                or (RIGHT(EXE_PATH, 5) = '/ncat' and CONTAINS(CMDLINE, ' -e'))
                or (CONTAINS(CMDLINE, 'xterm -display'))
                or (CONTAINS(CMDLINE, '.exec([\"/bin/bash\"'))
                or (CONTAINS(CMDLINE, '.spawn(\"/bin/sh\")'))
                or (CONTAINS(CMDLINE, 'subprocess.call([\"/bin/sh\"'))
            ) and (
              PROCESS_START_TIME >= (CURRENT_TIMESTAMP_SEC() - 7200)::Timestamp
            )
        }
        return distinct {
            MID,
            CMDLINE,
            EXE_PATH,
            PID,
            PID_HASH,
            PROCESS_START_TIME,
            USERNAME
        }
    }
EOT
}

resource "lacework_policy" "DETC_POTENTIAL_REVERSE_SHELL" {
  title       = "Potential Reverse Shell Found"
  description = "Potential Reverse Shell Found"
  remediation = "Investigate any suspicious activity."
  query_id    = lacework_query.DETC_PotentialReverseShell_Query.id
  severity    = "High"
  type        = "Violation"
  evaluation  = "Hourly"
  enabled     = true

  alerting {
    enabled = true
    profile = "LW_HE_PROCESSES_DEFAULT_PROFILE.HE_Process_NewViolation"
  }
}


output "agent-token" {
  value     = lacework_agent_access_token.detc-agent-token.token
  sensitive = true
}
