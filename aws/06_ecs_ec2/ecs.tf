resource "aws_ecs_capacity_provider" "asg-cp" {
  name = "asg-cp"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs_asg.arn
  }
}

resource "aws_ecs_cluster" "ecs-cluster-001" {
  name               = "ecs-cluster-001"
  capacity_providers = [aws_ecs_capacity_provider.asg-cp.name]
}

data "template_file" "wordpress_app" {
  template = file("./templates/ecs/wordpress_app.json.tpl")

  vars = {
    app_image  = var.app_image
    app_port   = var.app_port
    ecs_cpu    = var.ecs_cpu
    ecs_memory = var.ecs_memory
    aws_region = var.aws_region
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "wordpress-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = var.ecs_cpu
  memory                   = var.ecs_memory
  container_definitions    = data.template_file.wordpress_app.rendered
}

resource "aws_ecs_service" "wordpress" {
  name            = "wordpress-service"
  cluster         = aws_ecs_cluster.ecs-cluster-001.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type     = "EC2"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "wordpress-app"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs_task_execution_role]
}