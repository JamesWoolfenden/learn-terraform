resource "aws_iam_policy" "heredoc" {
  name        = "heredoc_policy"
  path        = "/"
  description = "An example policy"

  policy = "${data.aws_iam_policy_document.heredoc.json}"
}
