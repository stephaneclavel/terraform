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

  ami                         = aws_ami_copy.amazon-linux-2-encrypted-ami.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "mynewkeypair"
  monitoring                  = false
  vpc_security_group_ids      = [module.demo_sg.this_security_group_id]
  subnet_id                   = module.base-network.public_subnet_ids[0]

  user_data = file("bootstrap.sh")

  tags = local.common_tags

}
