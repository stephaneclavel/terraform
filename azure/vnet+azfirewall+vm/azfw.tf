resource "azurerm_subnet" "snet-demo-test-westeurope-002" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg-demo-test-westeurope-001.name
  virtual_network_name = azurerm_virtual_network.vnet-demo-test-westeurope-001.name
  address_prefixes     = ["10.0.254.0/24"]
}

resource "azurerm_public_ip" "pip-demo-test-westeurope-001" {
  name                = "azfw-pip"
  location            = azurerm_resource_group.rg-demo-test-westeurope-001.location
  resource_group_name = azurerm_resource_group.rg-demo-test-westeurope-001.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "azfw-demo-test-westeurope-001" {
  name                = "azfw-demo-test-westeurope-001"
  location            = azurerm_resource_group.rg-demo-test-westeurope-001.location
  resource_group_name = azurerm_resource_group.rg-demo-test-westeurope-001.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.snet-demo-test-westeurope-002.id
    public_ip_address_id = azurerm_public_ip.pip-demo-test-westeurope-001.id
  }
}

resource "azurerm_firewall_network_rule_collection" "azfwnrc-demo-test-westeurope-001" {
  name                = "azfwnrc-demo-test-westeurope-001"
  azure_firewall_name = azurerm_firewall.azfw-demo-test-westeurope-001.name
  resource_group_name = azurerm_resource_group.rg-demo-test-westeurope-001.name
  priority            = 100
  action              = "Allow"

  rule {
    name = "allow outbound DNS"

    source_addresses = [
      "10.0.0.0/16",
    ]

    destination_ports = [
      "53",
    ]

    destination_addresses = [
      "8.8.8.8",
      "8.8.4.4",
    ]

    protocols = [
      "TCP",
      "UDP",
    ]
  }
}

resource "azurerm_firewall_network_rule_collection" "azfwnrc-demo-test-westeurope-002" {
  name                = "azfwnrc-demo-test-westeurope-002"
  azure_firewall_name = azurerm_firewall.azfw-demo-test-westeurope-001.name
  resource_group_name = azurerm_resource_group.rg-demo-test-westeurope-001.name
  priority            = 110
  action              = "Allow"

  rule {
    name = "allow outbound www"

    source_addresses = [
      "10.0.0.0/16",
    ]

    destination_ports = [
      "80",
      "443",
    ]

    destination_addresses = [
      "*",
    ]

    protocols = [
      "TCP",
    ]
  }
}


resource "azurerm_firewall_nat_rule_collection" "natrc-demo-test-westeurope-001" {
  name                = "natrc-demo-test-westeurope-001"
  azure_firewall_name = azurerm_firewall.azfw-demo-test-westeurope-001.name
  resource_group_name = azurerm_resource_group.rg-demo-test-westeurope-001.name
  priority            = 100
  action              = "Dnat"

  rule {
    name = "allow inbound ssh"

    source_addresses = [
      var.mypublicip,
    ]

    destination_ports = [
      "22",
    ]

    destination_addresses = [
      azurerm_public_ip.pip-demo-test-westeurope-001.ip_address
    ]

    translated_port = 22

    translated_address = azurerm_network_interface.nic-demo-test-westeurope-001.private_ip_address

    protocols = [
      "TCP",
    ]
  }
}

resource "azurerm_firewall_nat_rule_collection" "natrc-demo-test-westeurope-002" {
  name                = "natrc-demo-test-westeurope-002"
  azure_firewall_name = azurerm_firewall.azfw-demo-test-westeurope-001.name
  resource_group_name = azurerm_resource_group.rg-demo-test-westeurope-001.name
  priority            = 110
  action              = "Dnat"

  rule {
    name = "allow inbound web"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "80",
    ]

    destination_addresses = [
      azurerm_public_ip.pip-demo-test-westeurope-001.ip_address
    ]

    translated_port = 80

    translated_address = azurerm_network_interface.nic-demo-test-westeurope-001.private_ip_address

    protocols = [
      "TCP",
    ]
  }
}


resource "azurerm_route_table" "rt-demo-test-westeurope-001" {
  location            = azurerm_resource_group.rg-demo-test-westeurope-001.location
  name                = "MyRouteTable"
  resource_group_name = azurerm_resource_group.rg-demo-test-westeurope-001.name
}

resource "azurerm_route" "rou-demo-test-westeurope-001" {
  name                   = "AzFirewallRoute"
  resource_group_name    = azurerm_resource_group.rg-demo-test-westeurope-001.name
  route_table_name       = azurerm_route_table.rt-demo-test-westeurope-001.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "virtualappliance"
  next_hop_in_ip_address = azurerm_firewall.azfw-demo-test-westeurope-001.ip_configuration[0].private_ip_address
}

resource "azurerm_subnet_route_table_association" "rta-demo-test-westeurope-001" {
  subnet_id      = azurerm_subnet.snet-demo-test-westeurope-001.id
  route_table_id = azurerm_route_table.rt-demo-test-westeurope-001.id
}
