resource "local_file" "pem-private" {
  content  = tls_private_key.ssh.private_key_pem
  filename = "${path.cwd}/id_rsa"
}

resource "local_file" "ssh-public" {
  content  = tls_private_key.ssh.public_key_openssh
  filename = "${path.cwd}/id_rsa.pub"
}