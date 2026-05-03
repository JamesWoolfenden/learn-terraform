module "codecommit" {
  source = "git::https://github.com/JamesWoolfenden/terraform-aws-codecommit.git?ref=e4a7717c615eeb4f674d3919cc6a03317c2f5c3f" #v0.3.62
  repository_name = var.repository_name
}
