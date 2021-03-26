## Objective

Deploy AWS EKS cluster. 

![alt text](https://github.com/stephaneclavel/terraform/blob/master/aws/09_eks/diagram.png?raw=true)

Slightly modified from: https://learn.hashicorp.com/tutorials/terraform/eks Added logs, API server public access filtering (client IP and NAT gateway Elastic IP address for nodes to contact API server) and few default setting for worker groups. 

Removed SSH remote access to use AWS SSM. See:
https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html

## Test

Run get-credentials.sh and test access with kubectl get nodes for example. 

## Note

This project leverages remote TF backend, see providers.tf file. 
