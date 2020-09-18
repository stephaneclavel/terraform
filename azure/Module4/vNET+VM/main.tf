provider "azurerm" {
    version = "2.9.0"
    subscription_id = var.subscriptionID

    features {}
}

#create resource group
resource "azurerm_resource_group" "rg" {
    name     = var.resourceGroupName 
    location = var.location
    tags      = {
      Environment = "Terraform Demo"
    }
}

resource "azurerm_network_security_group" "CloudskillsSG" {
  name                = "cloudSkillsSG"
  location            = var.location
#  resource_group_name = var.resourceGroupName
  resource_group_name = azurerm_resource_group.rg.name
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
  resource_group_name         = azurerm_network_security_group.CloudskillsSG.resource_group_name
  network_security_group_name = azurerm_network_security_group.CloudskillsSG.name
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
  resource_group_name         = azurerm_network_security_group.CloudskillsSG.resource_group_name
  network_security_group_name = azurerm_network_security_group.CloudskillsSG.name
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
  resource_group_name         = azurerm_network_security_group.CloudskillsSG.resource_group_name
  network_security_group_name = azurerm_network_security_group.CloudskillsSG.name
}

resource "azurerm_virtual_network" "cloudskills-vnet" {
  name                = "cloudskills-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["8.8.8.8", "8.8.4.4"]

  tags = {
    environment = "Dev"
  }
}

resource "azurerm_subnet" "cloudskills-sub" {
  name                 = "testsubnet"
  resource_group_name  = azurerm_network_security_group.CloudskillsSG.resource_group_name
  virtual_network_name = azurerm_virtual_network.cloudskills-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "cloudskills-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "cloudskills-nic-ip-config"
    subnet_id                     = azurerm_subnet.cloudskills-sub.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_public_ip" "cloudskills-publicIP" {
  name                = "cloudskills-publicIP"
  location            = "eastus"
  resource_group_name = azurerm_network_security_group.CloudskillsSG.resource_group_name
  allocation_method   = "Static"
  ip_version          = "IPv4"

  tags = {
    environment = "Dev"
        }   
    }


resource "azurerm_virtual_machine" "CloudskilsDevVM" {
  name                  = "cloudskillsvm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
#  network_interface_ids = ["${var.network_interface_id}"]
#  network_interface_ids = ["/subscriptions/${var.subscriptionID}/resourceGroups/${var.resourceGroupName}/providers/Microsoft.Network/networkInterfaces/${azurerm_network_interface.main.name}"]
  network_interface_ids = ["/subscriptions/${var.subscriptionID}/resourceGroups/${azurerm_resource_group.rg.name}/providers/Microsoft.Network/networkInterfaces/${azurerm_network_interface.main.name}"]
  vm_size               = "Standard_DS1_v2"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "cloudskillsdev01"
    admin_username = "azureuser"
    #admin_password = "W3lcomeWorld12!!"
    admin_password = var.admin_password
  }

  os_profile_linux_config {
# disable password auth as insecure to push on CVS
    disable_password_authentication = false
  }

  tags = {
    environment = "staging"
  }
}


