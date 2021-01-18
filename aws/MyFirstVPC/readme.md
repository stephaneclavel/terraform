!! At this stage one must go to console and associate private subnets with custom RT pointing to NAT instance !!

Objective is to deploy VPC as seen in AWS Certified Solutions Architect Associate SAA-C02 course https://linuxacademy.com/cp/modules/view/id/630 or similar to below set-up, leveraging existing TF modules. 

![Image of setup](https://docs.aws.amazon.com/vpc/latest/userguide/images/nat-instance-diagram.png)

This will deploy 1 VPC, 2 public subnets (1 per AZ), 2 private subnets (1 per AZ), Internet GW, custom SG, 3 instances:
- 1 jumpbox in public subnet
- 1 NAT instance in public subnet
- 1 private instance

Test: 
SSH to jumpbox, then to private instance. Test internet connectivity from this instance (sudo yum update)
