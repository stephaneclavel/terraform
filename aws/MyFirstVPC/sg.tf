data "http" "my_ip" {
  url = "http://ifconfig.me"
}

module "demo_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "allow-ssh"
  description = "Security group to allow inbound ssh from client ip"
  vpc_id      = module.base-network.vpc_id

  ingress_cidr_blocks = ["${data.http.my_ip.body}/32", module.base-network.public_subnet_cidr_blocks[0], module.base-network.public_subnet_cidr_blocks[1]]
  #  ingress_rules            = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh"
      #cidr_blocks = format("%s/32", data.http.my_ip.body)
      #cidr_blocks = "${data.http.my_ip.body}/32"
    }
  ]
}
