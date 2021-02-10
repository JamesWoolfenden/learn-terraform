resource "aws_lb" "apploadbalancer" {
  #checkov:skip=CKV_AWS_91: Example code
  name               = "app-load-balancer"
  load_balancer_type = "application"

  tags = var.common_tags
}
