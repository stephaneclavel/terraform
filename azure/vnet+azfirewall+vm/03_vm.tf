resource "azurerm_network_interface" "main" {
  name                = "vm-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "vm-nic-ip-config"
    subnet_id                     = module.vnet.vnet_subnets[0] #this output points to subnet id
    private_ip_address_allocation = "Dynamic"
  }
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
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_virtual_machine" "VM" {
  name                          = "vm"
  location                      = azurerm_resource_group.example.location
  resource_group_name           = azurerm_resource_group.example.name
  network_interface_ids         = ["/subscriptions/${var.subscriptionID}/resourceGroups/${azurerm_resource_group.example.name}/providers/Microsoft.Network/networkInterfaces/${azurerm_network_interface.main.name}"]
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
    enabled     = true
    storage_uri = azurerm_storage_account.example.primary_blob_endpoint
  }

  os_profile {
    computer_name  = "ubuntu01"
    admin_username = "steph"
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    # disable password auth as insecure to push on CVS
    disable_password_authentication = false
    ssh_keys {
      path     = "/home/steph/.ssh/authorized_keys"
      key_data = file("~/.ssh/id_rsa.pub")
    }
  }

}


