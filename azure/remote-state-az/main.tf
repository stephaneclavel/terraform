terraform {
  backend "azurerm" {
    resource_group_name  = "tstate"
    storage_account_name = "tstate250790"
    container_name       = "tstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  version = "2.9.0"
  features {}
}

resource "azurerm_resource_group" "state-demo-secure" {
  name     = "state-demo"
  location = "westeurope"

  tags = {
    env = "tf-demo"
  }
}
