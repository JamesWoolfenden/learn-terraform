# Local file

## Data source

Gets the contents of a file.

## Resource

### Makes files

- To write templated files to disk
```terraform
resource "local_file" "remote_state" {
  content  = data.template_file.remote_state.rendered
  filename = "remote_state.tf"
}
```

- Write ssh keys to disk for TLS provider
```terraform
resource "tls_private_key" "vpn" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "local_file" "public" {
  content  = tls_private_key.vpn.public_key_openssh
  filename = "id_rsa.public"
}

resource "local_file" "private" {
  content  = tls_private_key.vpn.private_key_pem
  filename = "id_rsa"
}
```

This will write out private and public keys for a ssh key that your generated.
