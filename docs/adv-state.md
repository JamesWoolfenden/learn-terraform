# State

## Moving to Terraform Remote State

Up to now all the examples have created a local state file, **terraform.tfstate**. If you are a lone developer operator then this could suffice, but if you lose that file or need to co-operate with other developers on changes a different approach is required.

## Local State

Have a look at the Terraform code you applied in the previous chapters, along with the files you wrote, you will see a file called **terraform.tfstate**.

Open it your editor, being careful not to change a thing.

```terrafrom
{
  "version": 4,
  "terraform_version": "0.12.10",
  "serial": 2,
  "lineage": "a20fb43f-c6e8-d766-37d1-dd9af05f7a7e",
  "outputs": {
    "availablity_zones": {
      "value": [
        "eu-west-1a",
        "eu-west-1b",
        "eu-west-1c"
      ],
      "type": [
        "list",
        "string"
      ]
    }
  },
  "resources": [
    {
      "mode": "data",
      "type": "aws_availability_zones",
      "name": "available",
      "provider": "provider.aws",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "blacklisted_names": null,
            "blacklisted_zone_ids": null,
            "id": "2019-11-06 14:17:11.2174491 +0000 UTC",
            "names": [
              "eu-west-1a",
              "eu-west-1b",
              "eu-west-1c"
            ],
            "state": "available",
            "zone_ids": [
              "euw1-az3",
              "euw1-az1",
              "euw1-az2"
            ]
          }
        }
      ]
    },
    {
      "mode": "data",
      "type": "aws_caller_identity",
      "name": "current",
      "provider": "provider.aws",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "account_id": "111111111111",
            "arn": "arn:aws:iam::111111111111:user/jameswoolfenden",
            "id": "2019-11-06 14:17:11.5923975 +0000 UTC",
            "user_id": "AAAAAAAAAAAAAAAAA"
          }
        }
      ]
    }
  ]
}
```

Re-apply the Terraform(This just to check that all is still working)

```shell
$ Terraform apply
...
```

After the apply is finished, rename the file **terraform.tfstate** to **terraform.tfstate.old**.

Now try to re-apply the same Terraform. If the sample you used created infrastructure you'll now see an error showing that it failed. Lots of issues about resource existing?

That's easily fixed by reverting your re-naming.

So losing your **terraform.tfstate** file isn't great. That file is also best not left on your machine or on any server, plus it might have information you don't want shared.
If you ever want to automate or cooperate on infrastructure you must have a better solution.

The easiest way to solve this, in the cloud, is the use of a "State bucket". A State bucket might make you think of AWS but the same principal applies to Azure and GCP.

### AWS State Bucket

For each AWS account you use Terraform with create a remote backend to store Terraform state.
Create folder and add **module.statebucket.tf**.

```terraform
module statebucket {
  source      = "JamesWoolfenden/statebucket/aws"
  version     = "0.2.25"
  common_tags = var.common_tags
}```

and a **provider.aws.tf**

```terraform
provider "aws" {
  region  = "eu-west-1"
  version = "2.31"
}

Run this once and it will create your state bucket named "${data.aws_caller_identity.current.account_id}-terraform-state".

Run it a second time and the state for creating the buckets is stored in the bucket by writing its own **remote.state.tf**

```terraform
terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "1232141412-terraform-state"
    key            = "state-bucket/terraform.tfstate"
    dynamodb_table = "dynamodb-state-lock"
    region         = "eu-west-1"
  }
}
```

## locking and unlock state buckets

When you add a state bucket you should also enable locking.
Locking is prevent clashes, when 2 developers/processes try to modify the same resource at the same time.
Should someone else be running your terraform at the same time via a state bucket you might see:

```shell
Error: Error locking state: Error acquiring the state lock: The process cannot access the file because another process has locked a portion of the file.
Lock Info:
  ID:        0e9bffe0-b181-c7ce-7155-beddbc24d829
  Path:      terraform.tfstate
  Operation: OperationTypePlan
  Who:       james.woolfenden@23043-5510
  Version:   0.11.11
  Created:   2019-03-18 22:21:55.075742 +0000 UTC
  Info:
Then you should wait until this pln/apply is over.
```

This can also occur if a lock was not released, If a previous run crashed or was cancelled then the lock maybe not be released?

You can then force an unlock, if you have locked your self then the forst step is kill any orphaned Terraform processes.

```shell
$ terraform force-unlock 0e9bffe0-b181-c7ce-7155-beddbc24d829
...
```

Terraform acquires a state lock to protect the state from being written
by multiple users at the same time. Please resolve the issue above and try
again. For most commands, you can disable locking with the "-lock=false"
flag, but this is not recommended.

## Versioning on the AWS bucket

Versioning on the S3 bucket is enable by the properties in **aws_s3_bucket.statebucket.tf**

```terraform
  versioning {
    enabled    = true
    mfa_delete = true
  }
```

## GCP and Azure

You can do a similar things with the other providers

### [Terraform Cloud](https://app.terraform.io) state

Sign up for a [Terraform Cloud account](https://app.terraform.io) and Create an organisation, and set up a workspace.

![Workspace](workspace.png)

You can have multiple workspaces per repository:
![Settings](settings.png)

Each workspace requires Authentication.
![Authentication](auth.png)

In your code Add or update your **terraform.tf** file to include:

```tf
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "wolf"

    workspaces {
      name = "terraform-aws-codebuild-exampleA-tfe"
    }
  }
}

```

## Recovering and importing State

If you need to recreate or import existing infrastructure there a three main ways:-

## Terraform import

Most resources support the import keyword, this is the oldest method and is the slowest:

```cli
terraform import aws_s3_bucket.whosebucketisitanyway whosebucketisitanyway
```

By itself will fail with:

```cli
Error: resource address "aws_s3_bucket.whosebucketisitanyway" does not exist in the configuration.

Before importing this resource, please create its configuration in the root module. For example:

resource "aws_s3_bucket" "whosebucketisitanyway" {
  # (resource arguments)
}
```

So you will need to make the file **aws_s3_bucket.whosebucketisitanyway.tf** to succesfully associate it.

```cli
resource "aws_s3_bucket" "whosebucketisitanyway" {
}
```

But you will notice that your still need to update your resource to match your actual state.

```cli
$ terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

aws_s3_bucket.whosebucketisitanyway: Refreshing state... [id=whosebucketisitanyway]

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # aws_s3_bucket.whosebucketisitanyway will be updated in-place
  ~ resource "aws_s3_bucket" "whosebucketisitanyway" {
      + acl                         = "private"
        arn                         = "arn:aws:s3:::whosebucketisitanyway"
        bucket                      = "whosebucketisitanyway"
        bucket_domain_name          = "whosebucketisitanyway.s3.amazonaws.com"
        bucket_regional_domain_name = "whosebucketisitanyway.s3.eu-west-1.amazonaws.com"
      + force_destroy               = false
        hosted_zone_id              = "Z1BKCTXD74EZPE"
        id                          = "whosebucketisitanyway"
        region                      = "eu-west-1"
        request_payer               = "BucketOwner"
        tags                        = {}

        versioning {
            enabled    = false
            mfa_delete = false
        }
    }

Plan: 0 to add, 1 to change, 0 to destroy.
```

## [Terraforming](https://github.com/dtan4/terraforming)

You'll need to install this. Terraforming can help with existing AWS infrastructure to generate the template.

```shell
$ aws s3 mb s3://whosebucketisitanyway
make_bucket: whosebucketisitanyway
$ aws s3 ls
2019-10-12 12:01:30 whosebucketisitanyway
$ terraforming s3
resource "aws_s3_bucket" "whosebucketisitanyway" {
    bucket = "whosebucketisitanyway"
    acl    = "private"
}
```

or the missing state:

```cli
$  terraforming s3 --tfstate
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

## [Terraformer](https://github.com/GoogleCloudPlatform/terraformer)

This is a more sophisticated tool and has support for many more providers. You will need to have set-up the providers already.

```cli
terraformer import aws --resources=s3 --regions=eu-west-1
2019/10/12 14:01:16 aws importing region eu-west-1
2019/10/12 14:01:16 aws importing... s3
2019/10/12 14:01:17 [TRACE] GRPCProvider: GetSchema
2019/10/12 14:01:17 [TRACE] GRPCProvider: Configure
2019/10/12 14:01:19 [TRACE] GRPCProvider: GetSchema
2019/10/12 14:01:19 [TRACE] GRPCProvider: GetSchema
2019/10/12 14:01:20 [TRACE] GRPCProvider: Configure
2019/10/12 14:01:21 Refreshing state... aws_s3_bucket.whosebucketisitanyway
2019/10/12 14:01:21 [TRACE] GRPCProvider: GetSchema
2019/10/12 14:01:21 [TRACE] GRPCProvider: ReadResource
2019/10/12 14:01:24 aws Connecting....
2019/10/12 14:01:24 aws save s3
2019/10/12 14:01:24 [DEBUG] New state was assigned lineage "4b60793a-54f0-acf6-7e9a-89242e7feb84"
2019/10/12 14:01:24 aws save tfstate for s3
```

This will make everything you need:

```cli
$ ls generated/aws/s3/eu-west-1 -l
total 4
-rwxrwxrwx 1 jim jim  106 Oct 12 14:32 outputs.tf
-rwxrwxrwx 1 jim jim   65 Oct 12 14:32 provider.tf
-rwxrwxrwx 1 jim jim  394 Oct 12 14:32 s3_bucket.tf
-rwxrwxrwx 1 jim jim 2460 Oct 12 14:32 terraform.tfstate
```
