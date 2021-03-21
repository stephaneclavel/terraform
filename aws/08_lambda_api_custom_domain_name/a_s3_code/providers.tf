terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.40.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tstate"
    storage_account_name = "tstate25079fr"
    container_name       = "tstate"
    key                  = "terraform.tfstate"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-3"
}
