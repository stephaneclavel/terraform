variable "resourceGroupName" {
    type = string
    description = "name of resource group"
}

variable "location" {
    type = string
    description = "location of your resource group"
}

variable "admin_password" {
    type = string
    description = "VM admin password"
    default = "Shouldnotusedefault!"
}

variable "mypublicip" {
    type = string
    description = "internet ip address"
}
