terraform {
  required_providers {
    aws = {
      version = "3.27.0"
      source  = "hashicorp/aws"
    }
    http = {
      version = "2.0.0"
      source  = "hashicorp/http"
    }
  }
  required_version = ">= 0.14"
}
