output "pip" {
  description = "VM public IP address"
  value = azurerm_public_ip.cloudskills-publicIP.ip_address
}
