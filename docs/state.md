# STATE

## What is this **terraform.tfstate** file

When you have run a terraform apply a state file is created **terraform.tfstate**.

A simple one looks like this:

```state
{
  "version": 4,
  "terraform_version": "0.12.10",
  "serial": 1,
  "lineage": "c00de4dd-b230-5181-5799-847ec00a257a",
  "outputs": {
    "account_id": {
      "value": "999999999999",
      "type": "string"
    }
  },
  "resources": [
    {
      "mode": "data",
      "type": "aws_caller_identity",
      "name": "current",
      "provider": "provider.aws",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "account_id": "999999999999",
            "arn": "arn:aws:iam::999999999999:user/jameswoolfenden",
            "id": "2019-10-12 10:24:39.2137408 +0000 UTC",
            "user_id": "AAAAAAAAAAAAAAAAA"
          }
        }
      ]
    }
  ]
}
```

The state file holds a record of inputs, outputs and resources created. A state file is a record of what infrastructure was made or that existed at the last run.

### Importance of setting version

The state file is written with the version number - see the line above

```terraform
"terraform_version": "0.12.10",
```

## The Golden Laws of State

### Don't ever delete your terraform.tfstate

### Don't check-in terraform.tfstate

Add a terraform.state to ensure this doesnt happen.

### Don't try to edit state files

You'll mess it up. Yes you will. It's like edit a SQL db by hand. That is also a sub-optimal idea.

### Do use a locking backend

More than one person trying to modify the same infrastructure at the same time? That doesn't work. In the long term you'll be controlling terraform and your infrastructure via a CI/CD process, but locking state is essential.
If your state is in S3 use [Dynamo](https://github.com/JamesWoolfenden/terraform-aws-statebucket/blob/master/aws_dynamno_table.dynamo-terraform-state-lock.tf).

### DONT PANIC

At times like these cooler head prevail, your second idea is probably wiser than your first. Don't compound your mistakes.

### Fix your Terraform version as Team in your Terraform Block

Add a File to your templates (**terraform.tf**) with content like:

```terraform
terraform {
   required_version="12.10"
}
```

You'll probably forget this at some point and one of you will make the state file incompatible for the team.

If you are adding this code to git. You are? no you are. Then add a .gitignore to the root of your repo based from <https://github.com/github/gitignore/blob/master/Terraform.gitignore>.
Also copy the pre-commit file and install it.

## State recovery/import

Ok so you broke your state file? Or you have a tonne of existing estate?

- Logging on S3 buckets

  - to find out who broke it.

- Import existing infra basics
  Most (BUT NOT ALL) resources have support for the import keyword, this can create a lot of work. If your doing a load it will be better to look at Terraforming.

This gives you the terraform, this gives you the state:

```cli
$ terraforming s3 --tfstate
{
  "version": 1,
  "serial": 1,
  "modules": [
    {
      "path": [
        "root"
      ],
      "outputs": {
      },
      "resources": {
        "aws_s3_bucket.whosebucketisitanyway": {
          "type": "aws_s3_bucket",
          "primary": {
            "id": "whosebucketisitanyway",
            "attributes": {
              "acl": "private",
              "bucket": "whosebucketisitanyway",
              "force_destroy": "false",
              "id": "whosebucketisitanyway",
              "policy": ""
            }
          }
        }
      }
    }
  ]
}
```
