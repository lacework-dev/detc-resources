terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.114.0"
    }
  }
  required_version = ">= 0.14"
}

provider "azurerm" {
  features {}
}


provider "azuread"{
  use_msi = true
}

resource "azurerm_resource_group" "example" {
  name     = "exampleresources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "main" {
  name                = "main-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "mainnic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "configurationname"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "mainvm"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"


  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "reporter-system-test"
    admin_username = "adminadmin"
    admin_password = "dadkjs07891234nmsdklj1123lk1jmnasdflkJLK!J2"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  identity {
    type = "SystemAssigned"
  }
}

















data "azurerm_client_config" "main" {
}
## Add key directly to instance
resource "azuread_application" "main" {
  for_each     = toset(["mac1", "artemis1", "liam1"])
  display_name = "tf-principal-${each.value}"
}

# Create Service Principal associated with the Azure AD App
resource "azuread_service_principal" "main" {
  client_id                    = azuread_application.main[each.key].client_id
  for_each                     = azuread_application.main
  # application_id               = each.value.application_id
  app_role_assignment_required = false
}

# Create service principal password
resource "azuread_application_password" "main" {
  for_each       = azuread_application.main
  application_id = each.value.id
}

data "azurerm_subscription" "primary" {}

variable "search"  { default = "//servicePrincipals//" }
variable "replace" { default = "" }

resource "azurerm_role_assignment" "main" {
  for_each             = azuread_service_principal.main
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = "${replace(each.value.id, var.search, var.replace)}"
  depends_on = [
    azuread_service_principal.main
  ]
}

locals {
  creds = merge({
    for k, v in azuread_application.main : k => tomap({
      client_id: v.client_id
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
