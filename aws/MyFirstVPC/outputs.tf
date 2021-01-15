output "public_instance_public_ip" {
  description = "Public instance public IP address"
  value       = module.ec2_public.public_ip
}

output "public_instance_dns" {
  description = "Public instance dns"
  value       = module.ec2_public.public_dns
}

output "private_instance_private_ip" {
  description = "Public instance public IP address"
  value       = module.ec2_private.private_ip
}

output "public_cidrs" {
  value       = module.base-network.public_subnet_cidr_blocks
}

output "private_cidrs" {
  value       = module.base-network.private_subnet_cidr_blocks
}

