module "codecommit" {
  source = "git::https://github.com/JamesWoolfenden/terraform-aws-codecommit.git?ref=170d66873a22e3c01dabc634b85646b48113122f" #v0.3.10
  repository_name = var.repository_name
}
