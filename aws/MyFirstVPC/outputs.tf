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

output "public_nat_instance_private_ip" {
  description = "Public instance NAT private IP address"
  value       = module.ec2_nat.private_ip
}

