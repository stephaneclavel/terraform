data "http" "my_ip" {
  url = "http://ifconfig.me"
}

module "demo_sg" {
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
    },
    {
      #rule        = "http-80-tcp"
      cidr_blocks = module.base-network.private_subnet_cidr_blocks[0]
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "http to nat gw"
      #cidr_blocks = "10.0.2.0/24"
    },
    {
      #rule        = "http-80-tcp"
      cidr_blocks = module.base-network.private_subnet_cidr_blocks[1]
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "http to nat gw"
      #cidr_blocks = "10.0.2.0/24"
    },
    {
      cidr_blocks = module.base-network.private_subnet_cidr_blocks[0]
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "https to nat gw"
    },
    {
      cidr_blocks = module.base-network.private_subnet_cidr_blocks[1]
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "https to nat gw"
    }
  ]
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_with_cidr_blocks = [
    {
      rule = "all-all"
    }
  ]
}
