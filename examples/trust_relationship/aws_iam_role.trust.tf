resource "aws_iam_role" "trust" {
  name               = "trust_role"
  assume_role_policy = "${data.aws_iam_policy_document.trust.json}"
}
