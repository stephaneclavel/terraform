resource "vcd_vapp" "tf_linux_vapp" {
  name      = "tf_linux_vapp"
}

resource "vcd_vapp_vm" "tf_linux_vm" {
  vapp_name     = vcd_vapp.tf_linux_vapp.name
  name          = "tf_linux_vm"
  computer_name = "tf-linux-vm"
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

  customization {
      enabled                   = true
      auto_generate_password    = true
  }
}

