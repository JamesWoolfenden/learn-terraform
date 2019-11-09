# Transport Layer Security - TLS

The TLS provider can be used to generate SSH keys, CSR's and self signed certs for SSL.

## SSH keys
```terraform
resource "tls_private_key" "ssh" {
  count     = length(var.key_names)
  algorithm = "RSA"
  rsa_bits  = "2048"
}
```
