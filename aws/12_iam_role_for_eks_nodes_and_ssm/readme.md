## Objective

Create role and instance profile for project 09, AWS EKS cluster. 

In project 09, EKS workers nodes use pre-built IAM role. This IAM role and instances profile have SSM and necessary EKS worker nodes permissions assigned:
![alt text](https://github.com/stephaneclavel/terraform/blob/master/aws/09_eks/iam-role.png?raw=true)

## Test

aws iam list-attached-role-policies --role-name EksWorkerNodesSsm
aws iam get-instance-profile --instance-profile-name EksWorkerNodesSsm

## Note

This project leverages remote TF backend, see providers.tf file. 
