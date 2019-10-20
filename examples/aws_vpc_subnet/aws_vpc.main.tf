resource "aws_vpc" "main" {
  cidr_block = var.cidr
  tags       = var.common_tags
}
