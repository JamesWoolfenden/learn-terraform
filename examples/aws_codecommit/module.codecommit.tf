module "codecommit" {
  source          = "JamesWoolfenden/codecommit/aws"
  version         = "v0.3.10"
  repository_name = var.repository_name
}
