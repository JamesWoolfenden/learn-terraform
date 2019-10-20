resource "aws_dynamodb_table" "dynamodb-state-lock" {
  name           = "dynamodb-state-lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.common_tags
}
