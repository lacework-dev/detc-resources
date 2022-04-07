terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.66.0"
    }
  }
  required_version = ">= 0.14"
}

provider "azurerm" {
  features {}
}

resource "azuread_application" "jenkins" {
  display_name = "jenkins"
}

resource "azuread_service_principal" "jenkins-sp" {
  application_id               = azuread_application.jenkins.id
  app_role_assignment_required = false
}

resource "azuread_application_password" "jenkins-sp" {
  application_object_id = azuread_service_principal.jenkins-sp.id
}

data "azurerm_subscription" "primary" {}

resource "azurerm_role_assignment" "main" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.jenkins-sp.id
  depends_on = [
    azuread_service_principal.jenkins-sp
  ]
}

output "client_id" {
  value     = azuread_application.jenkins.id
  sensitive = true
}

output "client_secret" {
  value     = azuread_application_password.jenkins-sp.value
  sensitive = true
}

output "tenant_id" {
  value     = data.azurerm_subscription.primary.tenant_id
  sensitive = true
}

output "sub_id" {
  value     = data.azurerm_subscription.primary.subscription_id
  sensitive = true
}

output "app_name" {
  value     = azuread_application.jenkins.display_name
  sensitive = true
}
