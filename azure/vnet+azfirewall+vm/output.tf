output "vm-pip" {
  description = "VM public IP address"
  value       = azurerm_public_ip.pip-demo-test-westeurope-001.ip_address
}

output "azfw-pip" {
  description = "AZ fw public IP address"
  value       = azurerm_public_ip.pip-demo-test-westeurope-002.ip_address
}

