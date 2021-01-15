locals {
  common_tags = {
    env   = var.env
    owner = var.owner
  }
}

# Create a VPC
resource "aws_vpc" "vpc-demo-test-euwest3-001" {
  cidr_block = "10.0.0.0/16"

  tags = local.common_tags

}

