terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"

    }
  }

  backend "azurerm" {
    resource_group_name  = "tstate"
    storage_account_name = "tstate250790"
    container_name       = "terratest"
    key                  = "2-azure-vm-test.tfstate"
  }

}

provider "azurerm" {
  features {}
}
