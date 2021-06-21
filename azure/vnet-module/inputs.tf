locals {
  common_tags = {
    env   = var.env
    owner = var.owner
  }
}

data "http" "my_ip" {
  url = "http://ifconfig.me"
}

resource "azurerm_resource_group" "rg-demo-test-westeurope-001" {
  name     = "rg-demo-test-westeurope-001"
  location = "westeurope"

  tags = local.common_tags

}

module "vnet" {
  source              = "Azure/vnet/azurerm"
  resource_group_name = azurerm_resource_group.rg-demo-test-westeurope-001.name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]
  vnet_name           = "vnet-demo-test-westeurope-001"

  nsg_ids = {
    subnet1 = azurerm_network_security_group.nsg-demo-test-westeurope-001.id
    subnet2 = azurerm_network_security_group.nsg-demo-test-westeurope-001.id
    subnet3 = azurerm_network_security_group.nsg-demo-test-westeurope-001.id
  }

  route_tables_ids = {
    subnet1 = azurerm_route_table.rt-demo-test-westeurope-001.id
    subnet2 = azurerm_route_table.rt-demo-test-westeurope-001.id
    subnet3 = azurerm_route_table.rt-demo-test-westeurope-001.id
  }

  subnet_service_endpoints = {
    subnet2 = ["Microsoft.Storage", "Microsoft.Sql"],
    subnet3 = ["Microsoft.AzureActiveDirectory"]
  }

  tags = {
    env = "tf-demo"
  }

  depends_on = [azurerm_resource_group.rg-demo-test-westeurope-001]
}

resource "azurerm_network_security_group" "nsg-demo-test-westeurope-001" {
  #  depends_on          = [module.vnet]
  name                = "nsg-demo-test-westeurope-001"
  location            = azurerm_resource_group.rg-demo-test-westeurope-001.location
  resource_group_name = azurerm_resource_group.rg-demo-test-westeurope-001.name

  security_rule {
    name                       = "port22"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = data.http.my_ip.body
    destination_address_prefix = "*"
  }

}

resource "azurerm_route_table" "rt-demo-test-westeurope-001" {
  location            = azurerm_resource_group.rg-demo-test-westeurope-001.location
  name                = "rt-demo-test-westeurope-001"
  resource_group_name = azurerm_resource_group.rg-demo-test-westeurope-001.name
}

resource "azurerm_route" "ro-demo-test-westeurope-001" {
  name                = "acceptanceTestRoute1"
  resource_group_name = azurerm_resource_group.rg-demo-test-westeurope-001.name
  route_table_name    = azurerm_route_table.rt-demo-test-westeurope-001.name
  address_prefix      = "10.1.0.0/16"
  next_hop_type       = "vnetlocal"
}
