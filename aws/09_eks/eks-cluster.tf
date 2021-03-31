data "http" "my_ip" {
  url = "http://ifconfig.me"
}

module "eks" {
  source                               = "terraform-aws-modules/eks/aws"
  cluster_name                         = local.cluster_name
  cluster_version                      = "1.19"
  subnets                              = module.vpc.private_subnets
  cluster_endpoint_public_access_cidrs = ["${data.http.my_ip.body}/32", "${module.vpc.nat_public_ips[0]}/32"]
  cluster_enabled_log_types            = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  tags = {
    Environment = "test",
    Project     = "09_eks"
  }

  vpc_id = module.vpc.vpc_id

  workers_role_name           = var.role_instance_profile
  manage_worker_iam_resources = false

  workers_group_defaults = {
    root_volume_type  = "gp2"
    health_check_type = "EC2"
    #install SSM agent and disable ssh access
    additional_userdata = "yum install -y https://s3.eu-west-3.amazonaws.com/amazon-ssm-eu-west-3/latest/linux_amd64/amazon-ssm-agent.rpm"
    #key_name                      = "mynewkeypair"
    iam_instance_profile_name = var.role_instance_profile
  }

  worker_groups = [
    {
      name                 = "worker-group-1"
      instance_type        = "t2.small"
      asg_desired_capacity = 2
      #install SSM agent and no ssh required
      #additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
    {
      name          = "worker-group-2"
      instance_type = "t2.medium"
      #install SSM agent and no ssh required
      #additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      asg_desired_capacity = 1
    },
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
