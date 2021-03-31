variable "region" {
  description = "AWS region"
  default     = "eu-west-3"
}

variable "role_instance_profile" {
  description = "Worker nodes role and instance profile name"
  default     = "EksWorkerNodesSsm"
}