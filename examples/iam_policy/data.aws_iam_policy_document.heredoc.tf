data "aws_iam_policy_document" "heredoc" {
	# checkov:skip=CKV_AWS_109: Simplified example
	# checkov:skip=CKV_AWS_111: Simplified example
	# checkov:skip=CKV_AWS_107: Simplified example
  statement {
    actions = [
      "ec2:*",
    ]

    resources = [
      "*",
    ]
  }
}
