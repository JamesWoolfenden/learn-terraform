# Creating an S3 bucket with Terraform

One of the oldest components of AWS - S3 is easily provisionable.

Starting off with a new scaffold:

```cli
$scaffold aws_bucket
```

and then add **aws_s3_bucket.Hyacinth.tf**

```terraform
resource "aws_s3_bucket" "hyacinth" {
  bucket = "hyacinth-bucket"
  acl    = "private"

  tags   = var.common_tags
}
```

And Apply.

You can easily check its creation with the AWS cli, or the console if you must.

```cli
$aws s3 ls hyacinth-bucket
```

Nothing else will be seen as the bucket is currently empty.

An S3 bucket comes with a large number of configuration possibilities, from hosting a website to data lake.

But there is one type of S3 bucket that we always need on an AWS Terraform project, and that's a State bucket.

## Making a State bucket

Replace the contents of the S3 Terraform file from the previous step, with:

```terraform
resource "aws_s3_bucket" "statebucket" {
  bucket        = "${data.aws_caller_identity.current.account_id}-terraform-state"
  acl           = "private"
  force_destroy = "false"

  versioning {
    enabled    = true
    mfa_delete = true
  }

  tags = var.common_tags
}
```

!!! Note Callouts
    Notice that this is a private bucket and that it has versioning and delete protection.

and add the file **data.aws_caller_identity.current.tf** to return the AWS account number.

```terraform
data "aws_caller_identity" "current" {}
```

and the file **aws_dynamodb_table.dynamodb-state-lock.tf**, to help stop concurrent writes.

```terraform
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
```

With that applied, you will have an S3 locking and versioned Terraform State bucket, that you use for all your work. In this account.
Dont share state buckets across accounts. **DO NOT**

To fully implement you also need to add a reference file to all of your templates call it **remote_state.tf**, by using your account number and region, this bucket be different, it will be unique on a account basis.
The property "key" must be different on every template.

```terraform
terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "${account_number}-terraform-state"
    key            = "state-bucket/terraform.tfstate"
    dynamodb_table = "dynamodb-state-lock"
    region         = "eu-west-1"
  }
}
```

## Managing globally unique names

- prefix with account number
- can always friendly name endpoint in DNS

!!!Note Links
    [AWS Statebucket](https://registry.terraform.io/modules/JamesWoolfenden/statebucket/aws/0.2.25)
    
    [GCP Statebucket](https://registry.terraform.io/modules/JamesWoolfenden/statebucket/gcp/0.2.12)
    
    [Azure Statebucket](https://registry.terraform.io/modules/JamesWoolfenden/statebucket/azure/0.1.11)
