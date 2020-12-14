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
  name                = "example-network"
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

resource "azurerm_linux_virtual_machine_scale_set" "vmss-demo-test-westeurope-001" {
  name                = "vmss-demo-test-westeurope-001"
  resource_group_name = azurerm_resource_group.rg-demo-test-westeurope-001.name
  location            = azurerm_resource_group.rg-demo-test-westeurope-001.location
  sku                 = "Standard_F2"
  instances           = 1
  admin_username      = "steph"

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
      name      = "ipcfg-demo-test-westeurope-001"
      primary   = true
      subnet_id = azurerm_subnet.snet-demo-test-westeurope-001.id
    }
  }
}

