resource "aws_security_group" "employee" {
  description = "employee security group"
  vpc_id      = "vpc-6bfee20f"

  ingress {
    from_port   = 3306
    protocol    = "TCP"
    to_port     = 3306
    cidr_blocks = ["${module.host.ip}/32"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.common_tags
}
