terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.20.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.40.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tstate"
    storage_account_name = "tstate25079fr"
    container_name       = "tstate"
    key                  = "nginx-k8s.terraform.tfstate"
  }
}

# remote state from 09_eks project
data "terraform_remote_state" "eks" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tstate"
    storage_account_name = "tstate25079fr"
    container_name       = "tstate"
    key                  = "eks.terraform.tfstate"
  }
}

# Retrieve EKS cluster information
provider "aws" {
  region = data.terraform_remote_state.eks.outputs.region
}

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.cluster.name
    ]
  }
}
