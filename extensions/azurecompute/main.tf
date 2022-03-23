variable "instance_name" {
  description = "Name of the compute instance"
}

variable "region" {
  description = "Azure region"
}

provider "azurerm" {
  features {}
}

provider "tls" {
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_resource_group" "azrg" {
  name     = "${var.instance_name}-rg"
  location = "${var.region}"
}

resource "azurerm_virtual_network" "azvn" {
  name                = "${var.instance_name}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.azrg.location
  resource_group_name = azurerm_resource_group.azrg.name
}

resource "azurerm_subnet" "azsubnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.azrg.name
  virtual_network_name = azurerm_virtual_network.azvn.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "azpubip" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.azrg.location
  resource_group_name = azurerm_resource_group.azrg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "azni" {
  name                = "${var.instance_name}-nic"
  location            = azurerm_resource_group.azrg.location
  resource_group_name = azurerm_resource_group.azrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.azsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.azpubip.id
  }
}

resource "azurerm_linux_virtual_machine" "linuxvm" {
  name                = "${var.instance_name}-machine"
  resource_group_name = azurerm_resource_group.azrg.name
  location            = azurerm_resource_group.azrg.location
  size                = "Standard_F2"
  admin_username      = "ubuntu"
  network_interface_ids = [
    azurerm_network_interface.azni.id,
  ]

  admin_ssh_key {
    username   = "ubuntu"
    public_key = "${tls_private_key.ssh.public_key_openssh}"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

output "ip" {
  value = azurerm_linux_virtual_machine.linuxvm.public_ip_address
}

output "ssh_key" {
  value     = tls_private_key.ssh.private_key_pem
  sensitive = true
}
