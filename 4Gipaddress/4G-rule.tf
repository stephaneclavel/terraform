resource "vcd_nsxv_firewall_rule" "rule4G" {
  org          = "Test-ENG001"
  vdc          = "TEST-VDC1"
  edge_gateway = "TEST-VDC1-EG2"

  logging_enabled = "true"
  action          = "accept"

  name = "ssh from antibes 4G"

  source {
    ip_addresses = [var.myip]
  }

  destination {
    ip_addresses = ["57.191.5.196"]
  }

  service {
    protocol 	= "tcp"
    port	= "8082"
  }

  service {
    protocol    = "tcp"
    port        = "8083"
  }
}
