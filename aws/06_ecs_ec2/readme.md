## Source

https://github.com/bradford-hamilton/terraform-ecs-fargate

## Objective

Deploy Wordpress containers using ECS / EC2 behind AWS ELB (ALB). As is it does not make a lot of sense but is a building brick towards redundant WP site. Also creating relevant log group.

Note: there is a reason why AWS created Fargate. 

## Test

Connect to ALB URL (http) and get WordPress default web page. 
