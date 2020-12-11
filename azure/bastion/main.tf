provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg-demo-test-westeurope-001" {
  name     = "rg-demo-test-westeurope-001"
  location = "West Europe"

  tags = {
    env = "tf-demo"
  }
}

resource "azurerm_virtual_network" "vnet-demo-test-westeurope-001" {
  name                = "vnet-demo-test-westeurope-001"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg-demo-test-westeurope-001.location
  resource_group_name = azurerm_resource_group.rg-demo-test-westeurope-001.name
}

resource "azurerm_subnet" "snet-demo-test-westeurope-002" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg-demo-test-westeurope-001.name
  virtual_network_name = azurerm_virtual_network.vnet-demo-test-westeurope-001.name
  address_prefixes     = ["10.0.255.224/27"]
}

resource "azurerm_public_ip" "pip-demo-test-westeurope-002" {
  name                = "pip-demo-test-westeurope-002"
  location            = azurerm_resource_group.rg-demo-test-westeurope-001.location
  resource_group_name = azurerm_resource_group.rg-demo-test-westeurope-001.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "rg-demo-test-westeurope-001" {
  name                = "rg-demo-test-westeurope-001bastion"
  location            = azurerm_resource_group.rg-demo-test-westeurope-001.location
  resource_group_name = azurerm_resource_group.rg-demo-test-westeurope-001.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.snet-demo-test-westeurope-002.id
    public_ip_address_id = azurerm_public_ip.pip-demo-test-westeurope-002.id
  }
}

