data "http" "my_ip" {
  url = "http://ifconfig.me"
}

module "inbound_ssh" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "allow-ssh-inbound-all-outbound"
  description = "Security group to allow inbound ssh from client ip"
  vpc_id      = module.base-network.vpc_id

  ingress_cidr_blocks = ["${data.http.my_ip.body}/32", module.base-network.public_subnet_cidr_blocks[0], module.base-network.public_subnet_cidr_blocks[1]]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh"
    }
  ]
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_with_cidr_blocks = [
    {
      rule = "all-all"
    }
  ]
}

module "unfiltered_http" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "unfiltered_http"
  description = "SG to allow http from Internet"
  vpc_id      = module.base-network.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_with_cidr_blocks = [
    {
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
    }
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_with_cidr_blocks = [
    {
      rule = "all-all"
    }
  ]
}

