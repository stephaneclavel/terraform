Adapted from https://docs.microsoft.com/en-us/azure/developer/terraform/best-practices-end-to-end-testing
!!!!!!!!!!!
Warning : as is, if test fails, TF deployment is NOT detroyed !! Watch out for costs !! 
!!!!!!!!!!!

Added data resource to get dynamic public ip address: 
data "azurerm_public_ip" "vm1pip" {
  name                = azurerm_public_ip.pip.name
  resource_group_name = azurerm_resource_group.rg.name
  depends_on          = [azurerm_linux_virtual_machine.vm1]
}
This is required as output would otherwise return empty as dynamic public IP addresses are assigned when actually used. 

