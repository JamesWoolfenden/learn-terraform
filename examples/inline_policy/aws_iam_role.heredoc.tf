resource "aws_iam_role" "heredoc" {
  name               = "heredoc_role"
  assume_role_policy = data.aws_iam_policy_document.heredoc.json
}
