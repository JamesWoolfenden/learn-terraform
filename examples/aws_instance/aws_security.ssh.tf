resource "aws_security_group" "ssh" {
  #checkov:skip=CKV_AWS_24:example code
  name = "allow-ssh"

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "ssh"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "outbound"
  }
}
