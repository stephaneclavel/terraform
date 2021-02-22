resource "aws_placement_group" "pg_spread" {
  name     = "pg_spread"
  strategy = "spread"
}

resource "aws_launch_template" "lt-001" {
  name_prefix            = "lt-001"
  image_id               = aws_ami_from_instance.encrypted-web-server.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.inbound_ssh.this_security_group_id, module.unfiltered_http.this_security_group_id]
  user_data = filebase64("bootstrap-web-base64.sh")
}

resource "aws_autoscaling_group" "asg-001" {
  name                      = "asg-001"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 4
  force_delete              = true
  placement_group           = aws_placement_group.pg_spread.id
  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 2
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy                 = "capacity-optimized"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.lt-001.id
      }
    }
  }
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
  vpc_zone_identifier = [module.base-network.public_subnet_ids[0], module.base-network.public_subnet_ids[1]]
}
