output "onprem-vpn-gateway1-pip" {
  value = azurerm_public_ip.onprem-vpn-gateway1-pip.ip_address
}

output "onprem-vm-public_ip" {
  value = azurerm_public_ip.onprem-pip.ip_address
}

output "onprem-vm-private_ip" {
  value = azurerm_network_interface.onprem-nic.private_ip_address
}

output "hub-vpn-gateway1-pip" {
  value = azurerm_public_ip.hub-vpn-gateway1-pip.ip_address
}

output "hub-vm-private_ip" {
  value = azurerm_network_interface.hub-nic.private_ip_address
}

output "spoke1-vm-private_ip" {
  value = azurerm_network_interface.spoke1-nic.private_ip_address
}

output "spoke2-vm-private_ip" {
  value = azurerm_network_interface.spoke2-nic.private_ip_address
}

