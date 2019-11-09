# Elastic Container Registry

Create a folder and add **module.ecr.tf**:

```terraform
module ecr {
  source           = "github.com/JamesWoolfenden/terraform-aws-ecr"
  version          = "0.2.22"
  name             = var.name
  repositorypolicy = data.aws_iam_policy_document.allowlocals.json
}
```

and a repository policy

```terraform
data "aws_iam_policy_document" "allowlocals" {
  statement {
    sid = "AllowPushPull"

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}
```

The above policy allows any user from its own account have access.

This module has a full example to follow:

[https://github.com/JamesWoolfenden/terraform-aws-ecr/tree/master/example/exampleA](https://github.com/JamesWoolfenden/terraform-aws-ecr/tree/master/example/exampleA)

!!!Note
Following https://github.com/JamesWoolfenden/terraform-aws-ecr
