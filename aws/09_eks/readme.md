## Objective

Deploy AWS EKS cluster. 

![alt text](https://github.com/stephaneclavel/terraform/blob/master/aws/09_eks/diagram.png?raw=true)

Slightly modified from: https://learn.hashicorp.com/tutorials/terraform/eks Added logs, API server public access filtering (client IP and NAT gateway Elastic IP address for nodes to contact API server) and few default setting for worker groups. 

## Test

Run get-credentials.sh and test access with kubectl get nodes. 

## Note

This project leverages remote TF backend, see providers.tf file. 
