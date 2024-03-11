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
variable "dockerhub_user" {}
variable "dockerhub_password" {}

provider "lacework" {
  subaccount = var.lacework_subaccount
  account    = var.lacework_account
  api_key    = var.lacework_apikey
  api_secret = var.lacework_apisecret
}

resource "lacework_integration_docker_hub" "lw_docker_integration" {
  name = "Dockerhub Account Integration"
  username = var.dockerhub_user
  password = var.dockerhub_password
}
