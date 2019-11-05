terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "680235478471-terraform-state"
    key            = "state-bucket/terraform.tfstate"
    dynamodb_table = "dynamodb-state-lock"
    region         = "eu-west-1"
  }
}
