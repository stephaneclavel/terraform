## Objective

Deploy 2 Nginx pods on AWS EKS cluster (see project 09) and expose them using loadbalancer service type. 

![alt text](https://github.com/stephaneclavel/terraform/blob/master/aws/10_first_deployment_on_first_eks_cluster/diagram.png?raw=true)

Source: https://learn.hashicorp.com/tutorials/terraform/kubernetes-provider?in=terraform/kubernetes

## Test

Browse to LB URL.  

## Note

This project leverages remote TF backend, see providers.tf file. 
