resource "aws_lb" "apploadbalancer" {
  name               = "app-load-balancer"
  load_balancer_type = "application"

  tags = var.common_tags
}
