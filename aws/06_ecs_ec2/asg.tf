resource "aws_launch_configuration" "ecs_launch_config" {
  image_id                    = "ami-08b42a2167e4c521f"
  iam_instance_profile        = aws_iam_instance_profile.ecs_agent.name
  security_groups             = [aws_security_group.ecs_tasks.id, module.sg_ssh.this_security_group_id]
  user_data                   = "#!/bin/bash\nyum update -y\necho ECS_CLUSTER=ecs-cluster-001 >> /etc/ecs/ecs.config"
  instance_type               = "t2.micro"
  key_name                    = "mynewkeypair"
  name_prefix                 = "terraform-lc-"
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                 = "asg"
  vpc_zone_identifier  = [aws_subnet.private.0.id, aws_subnet.private.1.id, aws_subnet.private.2.id] 
  launch_configuration = aws_launch_configuration.ecs_launch_config.name

  desired_capacity          = 3
  min_size                  = 2
  max_size                  = 6
  health_check_grace_period = 300
  health_check_type         = "EC2"

  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }
}