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

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "azrg" {
  name     = "${var.instance_name}-rg"
  location = var.region
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
  admin_username      = "adminuser"
  admin_password      = var.password
  network_interface_ids = [
    azurerm_network_interface.azni.id,
  ]

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
}

output "ip" {
  value = azurerm_windows_virtual_machine.windowsvm.public_ip_address
}

output "user" {
  value = "adminuser"
}

output "password" {
  value     = var.password
  sensitive = true
}
