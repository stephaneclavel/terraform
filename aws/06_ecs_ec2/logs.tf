# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "wordpress_log_group" {
  name              = "/ecs/wordpress"
  retention_in_days = 30

  tags = {
    Name = "wordpress-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "wordpress_log_stream" {
  name           = "wordpress-log-stream"
  log_group_name = aws_cloudwatch_log_group.wordpress_log_group.name
}