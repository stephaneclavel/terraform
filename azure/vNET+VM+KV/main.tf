provider "azurerm" {
  version = "2.9.0"

  features {}
}

#create resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resourceGroupName
  location = var.location
  tags = {
    env   = "az104"
    owner = "steph"
  }
}

resource "azurerm_network_security_group" "CloudskillsSG" {
  name     = "cloudSkillsSG"
  location = var.location
  #  resource_group_name = var.resourceGroupName
  resource_group_name = azurerm_resource_group.rg.name
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

}

resource "azurerm_subnet" "cloudskills-sub" {
  name                 = "testsubnet"
  resource_group_name  = azurerm_network_security_group.CloudskillsSG.resource_group_name
  virtual_network_name = azurerm_virtual_network.cloudskills-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.cloudskills-sub.id
  network_security_group_id = azurerm_network_security_group.CloudskillsSG.id
}

resource "azurerm_network_interface" "main" {
  name                = "cloudskills-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "cloudskills-nic-ip-config"
    subnet_id                     = azurerm_subnet.cloudskills-sub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.cloudskills-publicIP.id
  }
}

resource "azurerm_public_ip" "cloudskills-publicIP" {
  name                = "cloudskills-publicIP"
  location            = "eastus"
  resource_group_name = azurerm_network_security_group.CloudskillsSG.resource_group_name
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

resource "azurerm_storage_account" "example" {
  name                     = local.storageaccountname
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

data "azurerm_key_vault_secret" "mySecret" {
  name         = "admin-password"
  key_vault_id = "/subscriptions/88e98c7d-911a-45db-87e2-c788bd626c53/resourceGroups/RG_keep/providers/Microsoft.KeyVault/vaults/KV-25092020"
}

resource "azurerm_virtual_machine" "CloudskilsDevVM" {
  name                          = "cloudskillsvm"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  network_interface_ids         = [azurerm_network_interface.main.id]
  vm_size                       = "Standard_DS1_v2"
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

  boot_diagnostics {
    enabled = true
    #storage_uri = "https://storageaccount18092020.blob.core.windows.net/"
    storage_uri = azurerm_storage_account.example.primary_blob_endpoint
  }

  os_profile {
    computer_name  = "cloudskillsdev01"
    admin_username = "steph"
    #admin_password = "W3lcomeWorld12!!"
    #admin_password = var.admin_password
    admin_password = data.azurerm_key_vault_secret.mySecret.value
  }


  os_profile_linux_config {
    # disable password auth as insecure to push on CVS
    disable_password_authentication = false
    /*    ssh_keys {
        path	 = "/home/steph/.ssh/authorized_keys"
        key_data = file("~/.ssh/id_rsa.pub") 
    } */
  }

}


