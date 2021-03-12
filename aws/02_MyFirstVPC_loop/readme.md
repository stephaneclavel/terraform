## Objective

Same project as 01_... but using count to loop EC2 instances creation. 

Objective is to deploy VPC as seen in AWS Certified Solutions Architect Associate SAA-C02 course https://linuxacademy.com/cp/modules/view/id/630 or similar to below set-up, leveraging existing TF modules. 

![Image of setup](https://docs.aws.amazon.com/vpc/latest/userguide/images/nat-instance-diagram.png)

## Outcomes

This will deploy 1 VPC, 2 public subnets (1 per AZ), 2 private subnets (1 per AZ), Internet GW, custom SG, 3 instances:
- 1 jumpbox in public subnet
- 1 NAT instance in public subnet (*)
- 1 private instance

## Notes

(*) NAT gateway puts you out of AWS free tier. 

!! Manual steps !! 
See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association#import
You can either:
- go to console and associate private subnets with custom RT pointing to NAT instance
- or you could also uncomment 4 lines route_table_association ressource in private-route-table.tf file and run "terraform import aws_route_table_association.custom_private_subnet_0 private-subnet-id/custom-private-RT-id" the ids are part of outputs. 
!! or select another TF module that allows to modify main RT (beyond time allocated for this project) !! 

Test: 
1/ SSH to jumpbox
ssh -i "/home/steph/mynewkeypair.pem" ec2-user@ec2-35-180-54-230.eu-west-3.compute.amazonaws.com
2/ then to private instance (push your ssh key on jumpbox)
[ec2-user@ip-10-0-0-80 ~]$ ssh -i mynewkeypair.pem 10.0.2.13
3/ Test internet connectivity from this instance (sudo yum update)
[ec2-user@ip-10-0-2-13 ~]$ sudo yum update
Loaded plugins: extras_suggestions, langpacks, priorities, update-motd
amzn2-core                                                                                   | 3.7 kB  00:00:00
amzn2extra-docker                                                                            | 3.0 kB  00:00:00
(1/5): amzn2-core/2/x86_64/group_gz                                                          | 2.5 kB  00:00:00
(2/5): amzn2-core/2/x86_64/updateinfo                                                        | 326 kB  00:00:00
(3/5): amzn2extra-docker/2/x86_64/updateinfo                                                 |   76 B  00:00:00
(4/5): amzn2extra-docker/2/x86_64/primary_db                                                 |  74 kB  00:00:00
(5/5): amzn2-core/2/x86_64/primary_db                                                        |  48 MB  00:00:00
...
