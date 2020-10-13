variable "location" {
  description = "Location of the network"
  default     = "westeurope"
}

variable "username" {
  description = "Username for Virtual Machines"
  default     = "steph"
}

variable "password" {}

variable "vmsize" {
  description = "Size of the VMs"
  default     = "Standard_DS1_v2"
}

variable "mypublicip" {
  description = "client public ip address"
}
