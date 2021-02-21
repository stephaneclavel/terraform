locals {
  common_tags = {
    env   = var.env
    owner = var.owner
  }
}

module "ec2_public" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = "ec2_public"
  instance_count = 1

  ami                         = "ami-00798d7180f25aac2"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "mynewkeypair"
  monitoring                  = true
  vpc_security_group_ids      = [module.demo_sg.this_security_group_id]
  subnet_id                   = module.base-network.public_subnet_ids[0]

  tags = local.common_tags

}

module "ec2_nat" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = "ec2_nat"
  instance_count = 1

  ami                         = "ami-000d84e1c6fd278b9"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "mynewkeypair"
  monitoring                  = true
  vpc_security_group_ids      = [module.demo_sg.this_security_group_id]
  subnet_id                   = module.base-network.public_subnet_ids[0]
  source_dest_check           = false

  tags = local.common_tags

}


module "ec2_private" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = "ec2_private"
  instance_count = 1

  ami                         = "ami-00798d7180f25aac2"
  instance_type               = "t2.micro"
  associate_public_ip_address = false
  key_name                    = "mynewkeypair"
  monitoring                  = true
  vpc_security_group_ids      = [module.demo_sg.this_security_group_id]
  subnet_id                   = module.base-network.private_subnet_ids[0]

  tags = local.common_tags

}

