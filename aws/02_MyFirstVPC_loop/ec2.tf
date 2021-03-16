locals {
  common_tags = {
    env   = var.env
    owner = var.owner
  }
}

locals {
  instances = jsondecode(file("ec2.json")).Instances
}

module "ec2" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 2.0"
  for_each                    = { for instance in local.instances : instance.name => instance }
  name                        = each.value["name"]
  instance_count              = each.value["instance_count"]
  ami                         = each.value["ami"]
  instance_type               = each.value["instance_type"]
  associate_public_ip_address = each.value["associate_public_ip_address"]
  key_name                    = each.value["key_name"]
  monitoring                  = each.value["monitoring"]
  source_dest_check           = each.value["source_dest_check"]
  vpc_security_group_ids      = [module.demo_sg.this_security_group_id]
  #subnet_id                   = module.base-network.public_subnet_ids[0]
  subnet_id = each.value["subnet"]
  tags      = local.common_tags

}


