variable "env" {
  type        = string
  description = "environment type"
}

variable "owner" {
  type        = string
  description = "resources owner"
}

variable "vpc_cidr" {
  type        = string
  description = "vpc cidr block"
  default     = "10.0.0.0/16"
}

