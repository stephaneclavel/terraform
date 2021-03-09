Objectives are:
- to generate encrypted Amazon linux AMI and provision an EC2 instance from it, with user-data, and create 2nd AMI from this EC2 instance. 
- create ASG, ASG policy, ALB and target group. 

Test is to browse to ALB public DNS entry value (http). Hit refresh and see LB in action. 

Creating Spot EC2 instances puts you out of AWS free tier, but if resources are destroyed within some reasonable time, you would only be charged a few cents. 