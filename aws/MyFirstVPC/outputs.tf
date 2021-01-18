output "public_instance_dns" {
  description = "Public instance dns"
  value       = module.ec2_public.public_dns
}

output "private_instance_private_ip" {
  description = "Public instance public IP address"
  value       = module.ec2_private.private_ip
}

