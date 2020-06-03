variable "vcd_user" {
    type        = string
    description = "vCloud username"
}
variable "vcd_pass" {
    type        = string
    description = "vCloud password"
}
variable "vcd_org" {
    type        = string
    description = "vCloud Organisation"
}
variable "vcd_vdc" {
    type        = string
    description = "vCloud vDC"
}
variable "vcd_site" {
    type        = string
    description = "vCloud URL"
}
variable "src_catalog" {
    description = "Catalog name"
}
variable "src_template" {
    description = "vApp template name"
}
variable "org_net" {}
variable "memory" {}
