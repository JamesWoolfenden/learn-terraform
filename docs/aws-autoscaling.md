# AutoScaling Groups

Autoscaling aims to maintain available resource inline with demands on those resources. This is horizontal scaling (Number of instances) not vertical (more tin/ram) and is is either scale out (increasing) scaling in (reduction) or to maintaining a resource level (launching new instances if failures occur).

There are now two ways to configure an Autoscaling Group in AWS.

## Launch configuration

This is the older way, create **aws_launch_configuration.web.tf** as below:

```terraform
resource "aws_launch_configuration" "web" {
  name          = "web_config"
  image_id      = data.aws_ami.xenial.id
  instance_type = "t2.micro"
}
```

If the properties in a launch configuration look familiar, its because they are used replace the **aws_instance** resoure, when combined with an Autoscaling group **aws_autoscaling_group.web.tf**.

```terraform
resource "aws_autoscaling_group" "web" {
  availability_zones   = ["eu-west-1a"]
  desired_capacity     = 1
  max_size             = 1
  min_size             = 1
  launch_configuration = aws_launch_configuration.web.id
}
```

Replacing one resource for two might not seem like an obvious gain, but functional it's big, now should you lose the instance a new one will be started automatically. A launch configuration can be used as a foundational component of a blue-green deployment strategy.

Typically this can be achieved by updating the AMI of the Launch config, and then Scaling out and then In, this action removes the oldest EC2 instance.

## Launch template

Launch templates are the new way, being almost identical to Launch configuration but with more support for parameters and support for multiple versions.

For our terraform example, swap out the launch configuration and add **aws_launch_template.web.tf**:

```terraform
resource "aws_launch_template" "web" {
  name_prefix   = "web"
  image_id      = data.aws_ami.xenial.id
  instance_type = "t2.micro"
}
```

Together with a small change to the scaling group.

```terraform
resource "aws_autoscaling_group" "web" {
  availability_zones = ["eu-west-1a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.web.id
    version = "$$Latest"
  }
}
```

TODO:extract numbers to tfvars
modify and reapply

### Autoscaling Policy

```terraform
resource "aws_autoscaling_policy" "defaultmetrics" {
  name                   = "web-default-scaling"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web.name
}
```

There's nothing very "smart" or reactive here yet. I'd like increase or decrease the capacity of the web tier in response to application performance metric.

TODO:scaling
no point scaling down paid for instances if not reserved?
EC2 instance
custom Metrics - cpu utilisation from hypervisor, io bound?

## Autoscaling groups for other objects

### Links

<https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html>
<https://www.terraform.io/docs/providers/aws/r/autoscaling_policy.html>
