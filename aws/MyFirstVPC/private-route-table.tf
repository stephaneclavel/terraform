resource "aws_route_table" "custom_private_subnet_route_table" {
  vpc_id = module.base-network.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = module.ec2_nat.id[0]
  }
}

#resource "aws_route_table_association" "custom_private_subnet_0" {
#  subnet_id      = module.base-network.private_subnet_ids[0]
#  route_table_id = aws_route_table.custom_private_subnet_route_table.id
#}

