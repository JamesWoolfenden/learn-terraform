# Terraform

The Old fashioned way of finding results from other Terraform projects output.

```terraform
data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    bucket = "1234567890-terraform-state"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}
```

A Better and more independent way now is to use datasources - these didn't use to exist.
