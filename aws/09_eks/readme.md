## Objective

Deploy AWS EKS cluster. 

![alt text](https://github.com/stephaneclavel/terraform/blob/master/aws/09_eks/diagram.png?raw=true)

Slightly modified from: https://learn.hashicorp.com/tutorials/terraform/eks Added logs, API server public access filtering (client IP and NAT gateway Elastic IP address for nodes to contact API server) and few default setting for worker groups. 

Removed SSH remote access to use AWS SSM. See:
https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html

EKS workers nodes use pre-built IAM role, specified in variables.tf file. This IAM role and instances profile have SSM and necessary EKS worker nodes permissions assigned:
![alt text](https://github.com/stephaneclavel/terraform/blob/master/aws/09_eks/iam-role.png?raw=true)
See project 12

## Test

Run get-credentials.sh and test access with kubectl get nodes for example. 

To test SSM : aws ec2 describe-instances --filters Name=tag-value,Values=09_eks | grep InstanceId and then aws ssm start-session --target <intance_id>

## Note

This project leverages remote TF backend, see providers.tf file. 
