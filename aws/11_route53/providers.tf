terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.20.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tstate"
    storage_account_name = "tstate25079fr"
    container_name       = "tstate-route53"
    key                  = "terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-west-3"
}