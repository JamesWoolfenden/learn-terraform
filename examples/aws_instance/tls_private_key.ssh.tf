resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}
