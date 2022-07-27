variable "network_name" {}
variable "address_space" {}
variable "address_prefix" {}

variable "region" {
  description = "Azure region"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "azrg" {
  name     = "${var.network_name}-rg"
  location = var.region
}

resource "azurerm_virtual_network" "azvn" {
  name                = "${var.network_name}-network"
  address_space       = [var.address_space]
  location            = azurerm_resource_group.azrg.location
  resource_group_name = azurerm_resource_group.azrg.name
}

resource "azurerm_subnet" "azsubnet" {
  name                 = "${var.network_name}-subnet"
  resource_group_name  = azurerm_resource_group.azrg.name
  virtual_network_name = azurerm_virtual_network.azvn.name
  address_prefixes     = [var.address_prefix]
}

output "subnet_id" {
  value = azurerm_subnet.azsubnet.id
}

output "network_id" {
  value = azurerm_virtual_network.azvn.id
}

output "resource_group_id" {
  value = azurerm_resource_group.azrg.id
}
