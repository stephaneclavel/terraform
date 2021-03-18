## Source

https://github.com/bradford-hamilton/terraform-ecs-fargate

## Objective

Deploy NGINX containers using ECS / Fargate behind AWS ELB (ALB). Also creating relevant log group. 

## Test

Connect to ALB URL (http) and get Nginx default web page. 

## Note

This project leverages remote TF backend, see providers.tf file. 