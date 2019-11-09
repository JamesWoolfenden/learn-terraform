# Cloudwatch

TODO

## Logs

Add agent
Setting

## Metrics

Add agent
Default metrics from hypervisor

## Cloudwatch events

from

```terraform
resource "aws_cloudwatch_event_rule" "eventrule" {
  description = "An Amazon CloudWatch Event rule has been created by AWS CodeCommit for the following repository: ${aws_codecommit_repository.repo.arn}."

  is_enabled = true

  event_pattern = <<PATTERN
{
  "source": [
    "aws.codecommit"
  ],
  "resources": [
    "${aws_codecommit_repository.repo.arn}"
  ],
  "detail-type": [
    "CodeCommit Pull Request State Change",
    "CodeCommit Comment on Pull Request",
    "CodeCommit Comment on Commit"
  ]
}
PATTERN
}
```

### event target

```terraform
resource "aws_cloudwatch_event_target" "target" {
  target_id = "codecommit_notification"
  rule      = aws_cloudwatch_event_rule.eventrule.name
  arn       = aws_sns_topic.notification.arn

  input_path = "$.detail.notificationBody"
}
```

!!!Note Links
https://github.com/JamesWoolfenden/terraform-aws-cloudwatch-s3
