# Template

Used to tranform template files with a selection of variables. In this case a templated IAM policy **key_policy.json.tpl**
Templates replacements in this format- \${account_id}.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${account_id}:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow access for Key Administrators",
      "Effect": "Allow",
      "Principal": {
        "AWS": ["${key_admin_arn}"]
      },
      "Action": [
        "kms:Create*",
        "kms:Describe*",
        "kms:Enable*",
        "kms:List*",
        "kms:Put*",
        "kms:Update*",
        "kms:Revoke*",
        "kms:Disable*",
        "kms:Get*",
        "kms:Delete*",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Allow use of the key",
      "Effect": "Allow",
      "Principal": {
        "AWS": ["${key_admin_arn}"]
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Allow attachment of persistent resources",
      "Effect": "Allow",
      "Principal": {
        "AWS": ["${key_admin_arn}"]
      },
      "Action": ["kms:CreateGrant", "kms:ListGrants", "kms:RevokeGrant"],
      "Resource": "*",
      "Condition": {
        "Bool": {
          "kms:GrantIsForAWSResource": "true"
        }
      }
    }
  ]
}
```

Is transformed by:

```terraform
data "template_file" "credstash_policy" {
  template = file("${path.module}/templates/key_policy.json.tpl")

  vars {
    key_admin_arn = aws_iam_role.role.arn
    account_id    = data.aws_caller_identity.current.account_id
  }
}
```

So that the rendered template can be used:

```
resource "aws_kms_key" "credstash" {
  depends_on = ["null_resource.waiter"]

  policy                  = data.template_file.credstash_policy.rendered
  deletion_window_in_days = 7
  is_enabled              = true
  enable_key_rotation     = true

  tags = var.common_tags
}
```
