terraform {
  required_providers {
    aws = {
      version = "3.50.0"
      source  = "hashicorp/google"
    }
  }
  required_version = ">= 0.14"
}
