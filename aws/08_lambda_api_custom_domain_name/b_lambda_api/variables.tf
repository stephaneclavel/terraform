variable "bucket" {
  description = "name of bucket containing code archive"
}

variable "key" {
  description = "bucket key"
}

variable "stage_name" {
  description = "API gw stage name"
  default     = "test"
}

variable "domain_name" {
  description = "API gateway custom fqdn"
  default     = "api.aws.decidela.net"
}

variable "zone_id" {
  description = "domain name"
  default     = "Z07391401FFYB3249GQ6A"
}