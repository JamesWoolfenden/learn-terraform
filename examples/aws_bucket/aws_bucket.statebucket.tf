resource "aws_s3_bucket" "statebucket" {
  bucket        = "${data.aws_caller_identity.current.account_id}-terraform-state"
  acl           = "private"
  force_destroy = "false"

  versioning {
    enabled    = true
    mfa_delete = true
  }

  tags = var.common_tags
}
