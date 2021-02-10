terraform {
  required_providers {
    aws = {
      version = "3.27.0"
      source  = "hashicorp/aws"
    }
    local = {
      version = "2.0.0"
      source  = "hashicorp/local"
    }
    tls = {
      version = "3.0.0"
      source  = "hashicorp/tls"
    }
  }
  required_version = ">= 0.14"
}
