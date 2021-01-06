locals {
  common_tags = {
    env   = var.env
    owner = var.owner
  }
}

resource "azurerm_resource_group" "rg-demo-test-westeurope-001" {
  name     = "rg-demo-test-westeurope-001"
  location = "westeurope"

  tags = local.common_tags

}

