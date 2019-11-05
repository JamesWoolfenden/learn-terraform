# Code Commit

AWS Codecommit is a managed Git service with your AWS account. It supports Git features such as PR's and integrates with IAM.

You can use an [existing module](https://github.com/JamesWoolfenden/terraform-aws-codecommit) or write your own.

This module combines IAM groups with Cloudwatch events and SNS to trigger on every change and can be set to branch protect a given branch.

The core resource is **aws_codecommit_repository.repo.tf**

```terraform
resource "aws_codecommit_repository" "repo" {
  repository_name = var.repository_name
  description     = var.repository_name
  default_branch  = var.default_branch
}
```

## Create a new Respository from scratch

Create a new folder **aws_codecommit**

Add a module reference **module.codecommit.tf**

```terraform
module "codecommit" {
  source  = "JamesWoolfenden/codecommit/aws"
  version = "0.2.53"
  repository_name = var.repository_name
}
```

Add your **variables.tf** with:

```terraform
variable "repository_name" {
  type        = string
  description = "The name of your GIT repository"
}
```

Add these additional outputs to a **outputs.tf**:

```terraform
output "clone_url_https" {
  value = module.codecommit.clone_url_https
}

output "clone_url_ssh" {
  value = module.codecommit.clone_url_ssh
}
```

And a property file with **main.auto.tfvars**

```HCL
repository_name = "Valyria"
```

Put this all together with:

```bash
terraform init
terraform apply
```

<img src="https://gist.github.com/JamesWoolfenden/9e4dcc56f9efb152f275a962b7081334/raw/afb25c8db8815f0166c5e0ef5d316285a851074c/termtosvg_gyl9_z48.svg?sanitize=true">

!!! Note For more details on the module used:
<https://registry.terraform.io/modules/JamesWoolfenden/codecommit/aws/0.2.53>
