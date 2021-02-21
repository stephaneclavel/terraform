output "public_instance_dns" {
  description = "Public instance dns"
  value       = module.ec2_public.public_dns
}
