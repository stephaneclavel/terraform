variable "location" {
  description = "The location to set for the resource group."
  type        = string
  default     = "westeurope"
}

variable "postfix" {
  description = "A postfix string to centrally mitigate resource name collisions."
  type        = string
  default     = "test"
}
