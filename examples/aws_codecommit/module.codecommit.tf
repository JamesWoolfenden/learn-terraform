module "codecommit" {
  source          = "JamesWoolfenden/codecommit/aws"
  version         = "0.2.53"
  repository_name = var.repository_name
}
