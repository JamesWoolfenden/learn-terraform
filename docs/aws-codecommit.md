# Code Commit

AWS Codecommit is a managed Git service with your AWS account. It supports Git features such as PR's and integrates with IAM.

You can use an [existing module](https://github.com/JamesWoolfenden/terraform-aws-codecommit) or write your own.

This module combines IAM groups with Cloudwatch events and SNS to trigger on every change and can be set to branch protect a given branch.

The core resource is **aws_codecommit_repository.repo.tf**

``` terraform
resource "aws_codecommit_repository" "repo" {
  repository_name = var.repository_name
  description     = var.repository_name
  default_branch  = var.default_branch
}
```

<https://registry.terraform.io/modules/JamesWoolfenden/codecommit/aws/0.2.53>
