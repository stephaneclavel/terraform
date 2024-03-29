terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.40.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

#create resource group
resource "azurerm_resource_group" "rg-demo-test-westeurope-001" {
  name     = var.resourceGroupName
  location = var.location
  tags = {
    env = "tf-demo"
  }
}

resource "azurerm_network_security_group" "nsg-demo-test-westeurope-001" {
  name                = "nsg-demo-test-westeurope-001"
  location            = var.location
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

resource "azurerm_virtual_network" "vnet-demo-test-westeurope-001" {
  name                = "vnet-demo-test-westeurope-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-demo-test-westeurope-001.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["8.8.8.8", "8.8.4.4"]

}

resource "azurerm_subnet" "snet-demo-test-westeurope-001" {
  name                 = "snet-demo-test-westeurope-001"
  resource_group_name  = azurerm_network_security_group.nsg-demo-test-westeurope-001.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-demo-test-westeurope-001.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "nsga-demo-test-westeurope-001" {
  subnet_id                 = azurerm_subnet.snet-demo-test-westeurope-001.id
  network_security_group_id = azurerm_network_security_group.nsg-demo-test-westeurope-001.id
}

resource "azurerm_network_interface" "nic-demo-test-westeurope-001" {
  name                = "nic-demo-test-westeurope-001"
  location            = azurerm_resource_group.rg-demo-test-westeurope-001.location
  resource_group_name = azurerm_resource_group.rg-demo-test-westeurope-001.name

  ip_configuration {
    name                          = "nicipconfig"
    subnet_id                     = azurerm_subnet.snet-demo-test-westeurope-001.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-demo-test-westeurope-001.id
  }
}

resource "azurerm_public_ip" "pip-demo-test-westeurope-001" {
  name                = "pip-demo-test-westeurope-001"
  location            = var.location
  resource_group_name = azurerm_network_security_group.nsg-demo-test-westeurope-001.resource_group_name
  allocation_method   = "Static"
  ip_version          = "IPv4"
}

resource "random_string" "storageaccountname" {
  length  = 12
  upper   = false
  number  = true
  lower   = true
  special = false
}

locals {
  storageaccountname = "storage${random_string.storageaccountname.result}"
}

resource "azurerm_storage_account" "st-demo-test-westeurope-001" {
  name                     = local.storageaccountname
  resource_group_name      = azurerm_resource_group.rg-demo-test-westeurope-001.name
  location                 = azurerm_resource_group.rg-demo-test-westeurope-001.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Data template Bash bootstrapping file
data "template_file" "linux-vm-cloud-init" {
  template = file("install-apache2.sh")
}

resource "azurerm_linux_virtual_machine" "vm-demo-test-westeurope-001" {
  name                  = "vm-demo-test-westeurope-001"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg-demo-test-westeurope-001.name
  network_interface_ids = [azurerm_network_interface.nic-demo-test-westeurope-001.id]
  size                  = "Standard_B1s"
  admin_username        = "steph"
  custom_data           = base64encode(data.template_file.linux-vm-cloud-init.rendered)
  #  priority              = "Spot"
  #  eviction_policy       = "Deallocate"

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = "vm-demo-test-westeurope-001-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.st-demo-test-westeurope-001.primary_blob_endpoint
  }

  admin_ssh_key {
    username   = "steph"
    public_key = file("~/.ssh/id_rsa.pub")
  }

}

resource "null_resource" "test1" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "./test-web.sh"
  }
  depends_on = [azurerm_linux_virtual_machine.vm-demo-test-westeurope-001]
}

resource "null_resource" "test2" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "./test-ssh.sh"
  }
  depends_on = [azurerm_linux_virtual_machine.vm-demo-test-westeurope-001]
}

