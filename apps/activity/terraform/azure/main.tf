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

## Add key directly to instance
resource "azuread_application" "main" {
  for_each     = toset(["mac", "artemis", "liam"])
  display_name = "tf-principal-${each.value}"
}

# Create Service Principal associated with the Azure AD App
resource "azuread_service_principal" "main" {
  for_each                     = azuread_application.main
  application_id               = each.value.application_id
  app_role_assignment_required = false
}

# Create service principal password
resource "azuread_application_password" "main" {
  for_each              = azuread_application.main
  application_object_id = each.value.id
}

data "azurerm_subscription" "primary" {}

resource "azurerm_role_assignment" "main" {
  for_each             = azuread_service_principal.main
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = each.value.id
  depends_on = [
    azuread_service_principal.main
  ]
}

locals {
  creds = merge({
    for k, v in azuread_application.main : k => tomap({
      client_id : v.application_id
      client_secret : azuread_application_password.main[k].value
      tenant_id : data.azurerm_subscription.primary.tenant_id
      sub_id : data.azurerm_subscription.primary.subscription_id
      app_name : v.display_name
    })
  })
}

output "creds" {
  value     = local.creds
  sensitive = true
}
