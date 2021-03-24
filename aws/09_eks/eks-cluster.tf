data "http" "my_ip" {
  url = "http://ifconfig.me"
}

module "eks" {
  source                               = "terraform-aws-modules/eks/aws"
  cluster_name                         = local.cluster_name
  cluster_version                      = "1.19"
  subnets                              = module.vpc.private_subnets
  cluster_endpoint_public_access_cidrs = ["${data.http.my_ip.body}/32","${module.vpc.nat_public_ips[0]}/32"]
  cluster_enabled_log_types            = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  tags = {
    Environment = "test"
  }

  vpc_id = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
    health_check_type             = "EC2"
    key_name                      = "mynewkeypair"
  }

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t2.medium"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      asg_desired_capacity          = 1
    },
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
