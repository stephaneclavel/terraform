# Configure the VMware vCloud Director Provider
provider "vcd" {
  user      = var.vcd_user
  password  = var.vcd_pass
  org       = var.vcd_org
  vdc       = var.vcd_vdc
  url       = "https://iaas-${var.vcd_site}.aticloud.aero/api"
  version   = "~> 2.8"
}
