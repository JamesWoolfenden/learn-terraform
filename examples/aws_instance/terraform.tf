terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.43.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.8.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.2.1"
    }
  }
  required_version = ">= 0.14"
}
