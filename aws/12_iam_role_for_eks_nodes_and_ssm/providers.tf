provider "aws" {
  region = "eu-west-3"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.20.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.40.0"
    }
  }

  required_version = "~> 0.14"

  backend "azurerm" {
    resource_group_name  = "tstate"
    storage_account_name = "tstate25079fr"
    container_name       = "tstate"
    key                  = "iam.terraform.tfstate"
  }
}

