variable "azure_app_id" {
  description = "Azure app ID"
}

variable "azure_location" {
  description = "Default Azure location"
}

variable "azure_subscription_id" {
  description = "Azure subscription ID"
}

variable "azure_tenant_id" {
  description = "Azure tenant ID"
}

variable "azure_password" {
  description = "Azure AZURE_PASSWORD"
}

variable "deployment_name" {
  description = "Name of deployment - used for the cluster name.  Example: rotate"
}

variable "instance_size" {
  default = "standard_ds2"
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.13.0"
    }
  }

  required_version = ">= 0.14"
}

locals {
  cluster_name = "aks-demo-${var.deployment_name}"
}

provider "azurerm" {
  features {}

  subscription_id = var.azure_subscription_id
  client_id       = var.azure_app_id
  client_secret   = var.azure_password
  tenant_id       = var.azure_tenant_id
}

resource "azurerm_network_security_group" "default" {
  name                = "${local.cluster_name}-sg"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_virtual_network" "default" {
  name                = "${local.cluster_name}-network"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.default.id
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_resource_group" "default" {
  name     = "${local.cluster_name}-rg"
  location = var.azure_location

  tags = {
    environment = var.deployment_name
  }
}

data "azurerm_subnet" "default" {
  name = "${local.cluster_name}-subnet"
  resource_group_name = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "${local.cluster_name}-aks"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "${local.cluster_name}-k8s"

  private_cluster_public_fqdn_enabled = true

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = var.instance_size
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.azure_app_id
    client_secret = var.azure_password
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    dns_service_ip = "10.1.0.10"
    docker_bridge_cidr = "170.10.0.1/16"
   service_cidr = "10.1.0.0/16"
  }

  tags = {
    environment = "demo"
  }
}

