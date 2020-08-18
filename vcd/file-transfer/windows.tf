resource "vcd_vapp" "tf_windows_vapp" {
  name      = "tf_windows_vapp"
}

resource "vcd_vapp_vm" "tf_windows_vm" {
  vapp_name     = vcd_vapp.tf_windows_vapp.name
  name          = "tf_windows_vm"
  computer_name = "tf-windows-vm"
  catalog_name  = var.src_catalog
  template_name = var.src_template
  memory        = var.memory
  power_on      = true

  network {
    type               = "org"
    name               = var.org_net
    ip_allocation_mode = "POOL"
    is_primary         = true
  }

  network {
    type               = "org"
    name               = var.org_net2
    ip_allocation_mode = "POOL"
    is_primary         = false
  }

  customization {
      enabled                   = true
      auto_generate_password    = true
  }

}

resource "vcd_vapp_vm" "tf_windows_vm2" {
  vapp_name     = vcd_vapp.tf_windows_vapp.name
  name          = "tf_windows_vm2"
  computer_name = "tf-windows-vm2"
  catalog_name  = var.src_catalog
  template_name = var.src_template
  memory        = var.memory
  power_on      = true

  network {
    type               = "org"
    name               = var.org_net
    ip_allocation_mode = "POOL"
    is_primary         = true
  }

  network {
    type               = "org"
    name               = var.org_net2
    ip_allocation_mode = "POOL"
    is_primary         = false
  }

  customization {
      enabled                   = true
      auto_generate_password    = true
  }

}

