resource "aws_instance" "web" {
  ami           = data.aws_ami.xenial.id
  instance_type = "t2.micro"
  tags          = var.common_tags
  key_name      = aws_key_pair.ssh.key_name

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_tokens = "required"
  }
}
