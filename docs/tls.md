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

Applying the full example in the *./examples/tls* gives:

```terraform
Outputs:

ssh = [
  {
    "algorithm" = "RSA"
    "ecdsa_curve" = "P224"
    "id" = "f64e9d90fea972869fed88ea8f0323bd47cb66b1"
    "private_key_pem" = "-----BEGIN RSA PRIVATE KEY-----xxx-----END RSA PRIVATE KEY-----\n"
    "public_key_fingerprint_md5" = "f6:4b:3d:cc:0a:f6:28:d4:d1:5d:8d:87:05:2d:51:ab"
    "public_key_openssh" = "ssh-rsa xxx"
    "public_key_pem" = "-----BEGIN PUBLIC KEY-----xxx-----END PUBLIC KEY-----\n"
    "rsa_bits" = 2048
  },
]
```
