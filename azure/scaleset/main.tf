provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg-demo-test-westeurope-001" {
  name     = "rg-demo-test-westeurope-001"
  location = "West Europe"

  tags = {
    env = "tf_demo"
  }
}

resource "azurerm_virtual_network" "vnet-demo-test-westeurope-001" {
  name                = "vnet-demo-test-westeurope-001"
  resource_group_name = azurerm_resource_group.rg-demo-test-westeurope-001.name
  location            = azurerm_resource_group.rg-demo-test-westeurope-001.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "snet-demo-test-westeurope-001" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg-demo-test-westeurope-001.name
  virtual_network_name = azurerm_virtual_network.vnet-demo-test-westeurope-001.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "nsg-demo-test-westeurope-001" {
  name                = "nsg-demo-test-westeurope-001"
  location            = azurerm_resource_group.rg-demo-test-westeurope-001.location
  resource_group_name = azurerm_resource_group.rg-demo-test-westeurope-001.name
}

resource "azurerm_network_security_rule" "Port80" {
  name                        = "Allow80"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.nsg-demo-test-westeurope-001.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg-demo-test-westeurope-001.name
}

resource "azurerm_network_security_rule" "Port443" {
  name                        = "Allow443"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.nsg-demo-test-westeurope-001.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg-demo-test-westeurope-001.name
}

resource "azurerm_network_security_rule" "Port22" {
  name                        = "Allow22"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.mypublicip
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.nsg-demo-test-westeurope-001.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg-demo-test-westeurope-001.name
}

resource "azurerm_subnet_network_security_group_association" "nsga-demo-test-westeurope-001" {
  subnet_id                 = azurerm_subnet.snet-demo-test-westeurope-001.id
  network_security_group_id = azurerm_network_security_group.nsg-demo-test-westeurope-001.id
}


resource "random_string" "fqdn" {
  length  = 6
  special = false
  upper   = false
  number  = false
}

resource "azurerm_public_ip" "pip-demo-test-westeurope-001" {
  name                = "pip-demo-test-westeurope-001"
  location            = azurerm_resource_group.rg-demo-test-westeurope-001.location
  resource_group_name = azurerm_resource_group.rg-demo-test-westeurope-001.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = random_string.fqdn.result
}

resource "azurerm_lb" "lbe-demo-test-westeurope-001" {
  name                = "lbe-demo-test-westeurope-001"
  location            = azurerm_resource_group.rg-demo-test-westeurope-001.location
  resource_group_name = azurerm_resource_group.rg-demo-test-westeurope-001.name
  sku	              = "Standard"
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pip-demo-test-westeurope-001.id
  }

}

resource "azurerm_lb_backend_address_pool" "bpe-demo-test-westeurope-001" {
  resource_group_name = azurerm_resource_group.rg-demo-test-westeurope-001.name
  loadbalancer_id     = azurerm_lb.lbe-demo-test-westeurope-001.id
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "lbp-demo-test-westeurope-001" {
  resource_group_name = azurerm_resource_group.rg-demo-test-westeurope-001.name
  loadbalancer_id     = azurerm_lb.lbe-demo-test-westeurope-001.id
  name                = "running-probe"
  port                = 80
}

resource "azurerm_lb_rule" "lbnatrule-demo-test-westeurope-001" {
  resource_group_name            = azurerm_resource_group.rg-demo-test-westeurope-001.name
  loadbalancer_id                = azurerm_lb.lbe-demo-test-westeurope-001.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  backend_address_pool_id        = azurerm_lb_backend_address_pool.bpe-demo-test-westeurope-001.id
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.lbp-demo-test-westeurope-001.id
}

# Data template Bash bootstrapping file
data "template_file" "linux-vm-cloud-init" {
  template = file("install-apache2.sh")
}

resource "azurerm_linux_virtual_machine_scale_set" "vmss-demo-test-westeurope-001" {
  name                = "vmss-demo-test-westeurope-001"
  resource_group_name = azurerm_resource_group.rg-demo-test-westeurope-001.name
  location            = azurerm_resource_group.rg-demo-test-westeurope-001.location
  sku                 = "Standard_F2"
  instances           = 2
  admin_username      = "steph"
  custom_data         = base64encode(data.template_file.linux-vm-cloud-init.rendered)
  zone_balance	      = true
  zones               = [1,2,3]

  admin_ssh_key {
    username   = "steph"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "nic-demo-test-westeurope-001"
    primary = true

    ip_configuration {
      name                                   = "ipcfg-demo-test-westeurope-001"
      primary                                = true
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpe-demo-test-westeurope-001.id]
      subnet_id                              = azurerm_subnet.snet-demo-test-westeurope-001.id
    }
  }
}

