output "public_instance_dns" {
  description = "Public instance dns"
  value       = module.ec2_public.public_dns
}

output "alb_dns" {
  description = "ALB DNS value"
  value = aws_lb.alb-001.dns_name
}
