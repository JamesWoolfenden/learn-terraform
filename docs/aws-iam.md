# Managing IAM with Terraform

## AWS IAM - Identity Access Management

Json based roles, user and policies. This is the authentication scheme at the heart of AWS.

## Create a policy with HEREDOC

IAM policies can be added via the console either using the AWS wizards or as JSON files.
You can add a Json polic in directly to your terraform policy if you use a HEREDOC.
A Heredoc allows you to paste in a multiline string.
**aws_iam_policy.heredoc.tf** below is an example of using a Heredoc in a policy statement.

```terraform
resource "aws_iam_policy" "heredoc" {
  name        = "heredoc_policy"
  path        = "/"
  description = "An example policy"

  policy = <<HEREDOC
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
HEREDOC
}
```

This will create a managed but unattached IAM policy.
Create a scaffold iam_policy and make the policy

```shell
$ scaffold iam_policy
git clone --depth=1 git@github.com:JamesWoolfenden/tf-scaffold.git iam_policy
Cloning into 'iam_policy'...
remote: Enumerating objects: 11, done.
remote: Counting objects: 100% (11/11), done.
remote: Compressing objects: 100% (8/8), done.
remote: Total 11 (delta 0), reused 6 (delta 0), pack-reused 0
Receiving objects: 100% (11/11), done.
```

You can check the policy creation in UI or via the cli.

```shell
$ aws iam get-policy --policy-arn arn:aws:iam::122121221:policy/heredoc_policy
{
    "Policy": {
        "PolicyName": "heredoc_policy",
        "PolicyId": "xxxxxxxxxxxxxxx",
        "Arn": "arn:aws:iam::122121221:policy/heredoc_policy",
        "Path": "/",
        "DefaultVersionId": "v1",
        "AttachmentCount": 0,
        "PermissionsBoundaryUsageCount": 0,
        "IsAttachable": true,
        "Description": "An example policy",
        "CreateDate": "2019-04-06T22:05:51Z",
        "UpdateDate": "2019-04-06T22:05:51Z"
    }
}
```

That's the old way of making a policy, you can now use data resources to build policies in Terraform.
The previous example can rewritten with a data.aws_iam_policy_document data resource.
Now delete your state file.
Add **data.aws_policy_document.heredoc.tf**

```terraform
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
```

And modify the policy reaource to use this data resource.

```terraform
resource "aws_iam_policy" "heredoc" {
  name        = "heredoc_policy"
  path        = "/"
  description = "An example policy"

  policy = "${data.aws_iam_policy_document.heredoc.json}"
}
```

and reimport the existing policy into the modified policy

```shell
$terraform import aws_iam_policy.heredoc arn:aws:iam::122121212:policy/heredoc_policy
```

and then re-plan. This should come back saying the policy is identical.
You can also use templates to create your policies but the data resource is the easiest way.

## Trust relationship

Allows other accounts to access resources in your account

<https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-user.html>

This policy attached to a role allows ECS containers to talk to the ecs-tasks endpoint:

```terraform
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
```

## Attaching policy to a role

When you use policies you might hear alot about 2 types of policies:

- Unmanaged/inline policy
  Inline policies are child objects of a role or user, and dont count in your account limit. They are good for creating policies that are not for re-use. A policy with a single responsibility or use.

In Terraform you can use an aws_iam_role_policy resource to create an inline policy on a role:

```terraform
resource "aws_iam_role_policy" "inline_policy" {
  name = "AWSCodePipelineServiceRole-${data.aws_region.current.name}-${var.name}"
  role = aws_iam_role.pipeline.id

  policy = <<POLICY
{
....
}
```

You can still use a **data.aws_iam_policy_document**.

- Managed Policy
  Managed policies have to be attached to users or groups, and go be attached to multiple IAM roles or users.

```terraform
resource "aws_iam_policy" "pipeline" {
  name        = "AWSCodePipelineServiceRole-${data.aws_region.current.name}-${var.name}"
  description = var.description
  path        = var.policypath

  policy = <<POLICY
{
....
}
```

This policy still isnt associated or attached to your role.
A policy is attached with an **aws_iam_role_policy_attachment** resource.

```terraform
resource "aws_iam_role_policy_attachment" "pipeline" {
  role       = aws_iam_role.pipeline.name
  policy_arn = aws_iam_policy.pipeline.arn
}
```

Issues with attaching policies

## Attaching a user to a group

## inline policy on a role/group

Create a role

## Assuming a role

## Instance profiles

!!! note "Tip Seeing the changes in a policy"

    Before Terraform 0.12, when you Terraform planned it was very difficult to be sure that there was any change, the output was unlear.

    ```Shell
      ~ module.codebuild.aws_iam_role_policy.codebuild_policy
          policy:   "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Sid\": \"\",\n      \"Effect\": \"Allow\",\n
                    \"Action\": \"*\",\n      \"Resource\": [\n        \"arn:aws:s3:::aws-lexbot-handler-553700203877-artifacts/*\",\n
                    \"arn:aws:s3:::aws-lexbot-handler-553700203877-artifacts\"\n      ]\n    },\n    {\n      \"Sid\": \"\",\n
                    \"Effect\": \"Allow\",\n      \"Action\": \"codebuild:*\",\n      \"Resource\":
                    \"arn:aws:codebuild:eu-west-1:553700203877:project/aws-lexbot-handler\"\n    },\n    {\n      \"Sid\": \"\",\n
                    \"Effect\": \"Allow\",\n      \"Action\": [\n        \"ssm:PutParameter\",\n        \"ssm:GetParameters\"\n      ],\n
                    \"Resource\": \"*\"\n    },\n    {\n      \"Sid\": \"\",\n      \"Effect\": \"Allow\",\n      \"Action\": [\n
                    \"logs:PutLogEvents\",\n        \"logs:CreateLogStream\",\n        \"logs:CreateLogGroup\"\n      ],\n
                    \"Resource\": \"*\"\n    },\n    {\n      \"Sid\": \"\",\n      \"Effect\": \"Allow\",\n      \"Action\": [\n
                    \"iam:PassRole\",\n        \"iam:ListRoles\"\n      ],\n      \"Resource\": \"*\"\n    }\n  ]\n}" => "{\n  \"Version\":
                    \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Sid\": \"\",\n      \"Effect\": \"Allow\",\n      \"Action\": \"*\",
                    \n      \"Resource\": [\n        \"arn:aws:s3:::aws-lexbot-handler-553700203877-artifacts/*\",\n
                    \"arn:aws:s3:::aws-lexbot-handler-553700203877-artifacts\"\n      ]\n    },\n    {\n      \"Sid\": \"\",\n
                    \"Effect\": \"Allow\",\n      \"Action\": \"codebuild:*\",\n      \"Resource\": \"*\"\n    },\n    {\n      \"Sid\":
                    \"\",\n      \"Effect\": \"Allow\",\n      \"Action\": \"ecr:*\",\n      \"Resource\": \"*\"\n    },\n    {\n
                    \"Sid\": \"\",\n      \"Effect\": \"Allow\",\n      \"Action\": [\n        \"ssm:PutParameter\",\n
                    \"ssm:GetParameters\"\n      ],\n      \"Resource\": \"*\"\n    },\n    {\n      \"Sid\": \"\",\n      \"Effect\":
                    \"Allow\",\n      \"Action\": [\n        \"logs:PutLogEvents\",\n        \"logs:CreateLogStream\",\n
                    \"logs:CreateLogGroup\"\n      ],\n      \"Resource\": \"*\"\n    },\n    {\n      \"Sid\": \"\",\n      \"Effect\":
                    \"Allow\",\n      \"Action\": [\n        \"iam:PassRole\",\n        \"iam:ListRoles\"\n      ],\n      \"Resource\":
                    \"*\"\n    }\n  ]\n}"
    ```

There aren't actually any differences. Well it takes a bit of effort with a prettifier to be sure.

### Extras

- assume roles and remote_state
  todo
- assume roles and provider
  todo
