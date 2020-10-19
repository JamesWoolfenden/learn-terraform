resource aws_s3_bucket statebucket {
  #checkov:skip=CKV_AWS_18: "Ensure the S3 bucket has access logging enabled"

  bucket        = "${data.aws_caller_identity.current.account_id}-terraform-state"
  acl           = "private"
  force_destroy = "false"

  versioning {
    enabled    = true
    mfa_delete = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = var.common_tags
}
