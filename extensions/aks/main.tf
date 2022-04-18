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

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.66.0"
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

resource "azurerm_resource_group" "default" {
  name     = "${local.cluster_name}-rg"
  location = var.azure_location

  tags = {
    environment = var.deployment_name
  }
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "${local.cluster_name}-aks"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "${local.cluster_name}-k8s"

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_D2_v5"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.azure_app_id
    client_secret = var.azure_password
  }

  role_based_access_control {
    enabled = true
  }

  tags = {
    environment = "demo"
  }
}

