data "aws_iam_policy_document" "heredoc" {
  statement {
    actions = [
      "ec2:*",
    ]

    resources = [
      "*",
    ]
  }
}
