provider "azurerm" {
  version = "2.9.0"
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
  priority                    = 1000
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
  priority                    = 1001
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
  storageaccountname = "stordemoweeu${random_string.storageaccountname.result}"
}

resource "azurerm_storage_account" "st-demo-test-westeurope-001" {
  name                     = local.storageaccountname
  resource_group_name      = azurerm_resource_group.rg-demo-test-westeurope-001.name
  location                 = azurerm_resource_group.rg-demo-test-westeurope-001.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

data "azurerm_key_vault_secret" "mySecret" {
  name         = "admin-password"
  key_vault_id = "/subscriptions/88e98c7d-911a-45db-87e2-c788bd626c53/resourceGroups/RG_keep/providers/Microsoft.KeyVault/vaults/KV-25092020"
}

resource "azurerm_virtual_machine" "vm-demo-test-westeurope-001" {
  name                          = "vm-demo-test-westeurope-001"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg-demo-test-westeurope-001.name
  network_interface_ids         = [azurerm_network_interface.nic-demo-test-westeurope-001.id]
  vm_size                       = "Standard_B1s"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.st-demo-test-westeurope-001.primary_blob_endpoint
  }

  os_profile {
    computer_name  = "vmdemowesteu001"
    admin_username = "steph"
    admin_password = data.azurerm_key_vault_secret.mySecret.value
  }

  os_profile_windows_config {
    provision_vm_agent       = true  
  }

}

# Virtual Machine Extension to Install IIS
resource "azurerm_virtual_machine_extension" "iis-vm-demo-test-westeurope-001-extension" {
  #depends_on=[azurerm_windows_virtual_machine.web-windows-vm]  name = "win-${random_string.random-win-vm.result}-vm-extension"
  name = "iis-vm-demo-test-westeurope-001-extension"
  virtual_machine_id = azurerm_virtual_machine.vm-demo-test-westeurope-001.id
  publisher = "Microsoft.Compute"
  type = "CustomScriptExtension"
  type_handler_version = "1.9"
  settings = <<SETTINGS
    { 
      "commandToExecute": "powershell Install-WindowsFeature -name Web-Server -IncludeManagementTools;"
    } 
  SETTINGS

}
