resource "aws_key_pair" "ssh" {
  key_name   = "id_rsa"
  public_key = tls_private_key.ssh.public_key_openssh
}
