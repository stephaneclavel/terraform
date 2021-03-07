resource "aws_alb_target_group" "lb-tg" {
  name     = "lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.base-network.vpc_id
}

resource "aws_lb" "alb-001" {
  name               = "alb-001"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.unfiltered_http.this_security_group_id]
  subnets            = module.base-network.public_subnet_ids[*]
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb-001.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.lb-tg.arn
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg-001.id
  alb_target_group_arn   = aws_alb_target_group.lb-tg.arn
}
