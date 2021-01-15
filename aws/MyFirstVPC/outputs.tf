output "pip" {
  description = "Public instance public IP address"
  value       = module.ec2_public.public_ip
}

output "dns" {
  description = "Public instance dns"
  value       = module.ec2_public.public_dns
}

