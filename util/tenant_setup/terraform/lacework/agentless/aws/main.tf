terraform {
  required_providers {
    lacework = {
      source  = "lacework/lacework"
      version = "1.10.0"
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

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "use2"
  region = "us-east-2"
}

provider "aws" {
  alias  = "usw1"
  region = "us-west-1"
}

provider "aws" {
  alias  = "usw2"
  region = "us-west-2"
}

// This module will create AWS account "global" resources such as IAM roles, an S3 bucket, and a Secret Manager secret.
// This will also create a new Cloud Account Integration within the Lacework console.
module "lacework_aws_agentless_scanning_global" {
  source  = "lacework/agentless-scanning/aws"
  version = "~> 0.6"

  global                    = true
  lacework_integration_name = "sidekick_from_terraform"
}

// The following modules should be included per-region where scanning will occur.
// This creates an ECS cluster, a VPC and VPC IG for that cluster, and an EventBridge trigger in this region.
// The trigger will start a periodic Task to snapshot and analyze EC2 volumes in this region.

// Create regional resources us-east-1
module "lacework_aws_agentless_scanning_region" {
  source  = "lacework/agentless-scanning/aws"
  version = "~> 0.6"

  regional                = true
  global_module_reference = module.lacework_aws_agentless_scanning_global
}

// Create regional resources us-east-2
module "lacework_aws_agentless_scanning_region_use2" {
  source  = "lacework/agentless-scanning/aws"
  version = "~> 0.6"

  providers = {
    aws = aws.use2
  }

  regional                = true
  global_module_reference = module.lacework_aws_agentless_scanning_global
}

// Create regional resources us-west-1
module "lacework_aws_agentless_scanning_region_usw1" {
  source  = "lacework/agentless-scanning/aws"
  version = "~> 0.6"

  providers = {
    aws = aws.usw1
  }

  regional                = true
  global_module_reference = module.lacework_aws_agentless_scanning_global
}

// Create regional resources us-west-2
module "lacework_aws_agentless_scanning_region_usw2" {
  source  = "lacework/agentless-scanning/aws"
  version = "~> 0.6"

  providers = {
    aws = aws.usw2
  }

  regional                = true
  global_module_reference = module.lacework_aws_agentless_scanning_global
}
