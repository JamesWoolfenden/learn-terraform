resource "aws_instance" "web" {
  ami           = data.aws_ami.xenial.id
  instance_type = "t2.micro"
  tags          = var.common_tags
}
