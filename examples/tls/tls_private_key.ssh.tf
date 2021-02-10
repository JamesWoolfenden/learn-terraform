resource "tls_private_key" "ssh" {
  count     = length(var.key_names)
  algorithm = "RSA"
  rsa_bits  = "2048"
}

variable "key_names" {
  default = ["vulcan"]
}

output "ssh" {
  value = tls_private_key.ssh
}
