provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "tstate"
    storage_account_name = "tstate25079"
    container_name       = "tstate"
    key                  = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.40.0"
    }
  }
}

resource "azurerm_resource_group" "rg-github-actions" {
  name     = "rg-github-actions"
  location = "westeurope"

  tags = {
    env = "github-actions-demo"
  }
}
