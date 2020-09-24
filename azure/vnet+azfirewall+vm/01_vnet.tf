provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg1"
  location = "North Europe"
}

module "vnet" {
  source              = "Azure/vnet/azurerm"
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24"]
  subnet_names        = ["subnet1"]

  nsg_ids = {
    subnet1 = azurerm_network_security_group.ssh.id
  }

   route_tables_ids = {
    subnet1 = azurerm_route_table.example.id
  }

  depends_on = [azurerm_resource_group.example]
}

resource "azurerm_network_security_group" "ssh" {
#  depends_on          = [module.vnet]
  name                = "ssh"
  location            = "North Europe"
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "ssh_from_mypublicip"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.mypublicip
    destination_address_prefix = "*"
  }

}

resource "azurerm_route_table" "example" {
  location            = azurerm_resource_group.example.location
  name                = "MyRouteTable"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_route" "example" {
  name                = "AzFirewallRoute"
  resource_group_name = azurerm_resource_group.example.name
  route_table_name    = azurerm_route_table.example.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "virtualappliance"
#  next_hop_in_ip_address = "10.0.254.4"
  next_hop_in_ip_address = azurerm_firewall.example.ip_configuration[0].private_ip_address
}
