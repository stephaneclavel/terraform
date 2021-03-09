output "public_instance_dns" {
  description = "Public instance dns"
  value       = module.ec2_public.public_dns
}

output "private_instance_private_ip" {
  description = "Public instance public IP address"
  value       = module.ec2_private.private_ip
}

output "custom_route_table" {
  description = "route table to be associated with private instance to use nat instance"
  value       = aws_route_table.custom_private_subnet_route_table.id
}
