variable "instance_name" {
  description = "Name of the compute instance"
}

variable "region" {
  description = "Azure region"
}

variable "password" {
  description = "Administrator Password"
}

variable "subnet_id" {
  description = "Subnet for VM"
}

variable "username" {
  description = "Windows user name"
}

provider "azurerm" {
  features {}
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "sg_tags" {
  type = map(string)
  default = {}
}

resource "azurerm_resource_group" "azrg" {
  name     = "${var.instance_name}-rg"
  location = var.region
}

resource "azurerm_public_ip" "azpubip" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.azrg.location
  resource_group_name = azurerm_resource_group.azrg.name
  allocation_method   = "Static"
  tags = var.sg_tags
}

resource "azurerm_network_interface" "azni" {
  name                = "${var.instance_name}-nic"
  location            = azurerm_resource_group.azrg.location
  resource_group_name = azurerm_resource_group.azrg.name
  tags = var.sg_tags
  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.azpubip.id
  }
}

resource "azurerm_windows_virtual_machine" "windowsvm" {
  name                = var.instance_name
  computer_name       = var.instance_name
  resource_group_name = azurerm_resource_group.azrg.name
  location            = azurerm_resource_group.azrg.location
  size                = "Standard_F2"
  admin_username      = var.username
  admin_password      = var.password
  network_interface_ids = [
    azurerm_network_interface.azni.id,
  ]
  tags = var.tags

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

locals {
  run_command = <<COMMAND
$cert = New-SelfSignedCertificate -CertstoreLocation Cert:\LocalMachine\My -DnsName $env:COMPUTERNAME
Enable-PSRemoting -SkipNetworkProfileCheck -Force
New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $cert.Thumbprint –Force
New-NetFirewallRule -DisplayName "Windows Remote Management (HTTPS-In)" -Name "Windows Remote Management (HTTPS-In)" -Profile Any -LocalPort 5986 -Protocol TCP
COMMAND
}

resource "azurerm_virtual_machine_extension" "winrm_listener" {
  depends_on           = [azurerm_windows_virtual_machine.windowsvm]
  name                 = "extension"
  virtual_machine_id   = azurerm_windows_virtual_machine.windowsvm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  settings             = jsonencode({ "commandToExecute" = "powershell.exe -ExecutionPolicy Unrestricted -encodedCommand ${textencodebase64(local.run_command, "UTF-16LE")}" })
  tags = var.tags
}


resource "azurerm_network_interface_security_group_association" "nisga" {
  network_interface_id      = azurerm_network_interface.azni.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.instance_name}-nsg"
  location            = azurerm_resource_group.azrg.location
  resource_group_name = azurerm_resource_group.azrg.name
  tags = var.sg_tags

  security_rule {   //Here opened WinRMport
    name                       = "winrm"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5986"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {   //Here opened WebDAV
    name                       = "webdav"
    priority                   = 1011
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

output "ip" {
  value = azurerm_windows_virtual_machine.windowsvm.public_ip_address
}

output "user" {
  value = var.username
}

output "password" {
  value     = var.password
  sensitive = true
}
