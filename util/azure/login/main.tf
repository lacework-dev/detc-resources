terraform {
  required_providers {
  }
}

variable "azure_tenant_id" {
  description = "Azure tenant ID"
}

variable "azure_subscription" {
  description = "Azure subscription ID"
}

variable "azure_app_id" {
  description = "Azure App ID"
}

variable "azure_password" {
  description = "Azure App Password"
}


resource "null_resource" "azlogin" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "az login --service-principal -u \"$APP_ID\" -p \"$PASSWORD\" --tenant \"$TENANT_ID\" && az account set --subscription $SUBSCRIPTION"

    environment = {
      TENANT_ID = var.azure_tenant_id
      SUBSCRIPTION = var.azure_subscription
      APP_ID = var.azure_app_id
      PASSWORD = var.azure_password
    }
  }

}
