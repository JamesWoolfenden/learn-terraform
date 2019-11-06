# Creating an Application load balancer (ALB) with Terraform

Use scaffold to create aws_alb

```bash
$ scaffold aws_alb
git clone --depth=1 git@github.com:JamesWoolfenden/tf-scaffold.git aws_alb
Cloning into 'aws_alb'...
remote: Enumerating objects: 11, done.
remote: Counting objects: 100% (11/11), done.
remote: Compressing objects: 100% (8/8), done.
remote: Total 11 (delta 0), reused 6 (delta 0), pack-reused 0
Receiving objects: 100% (11/11), done.
```

Then we can add an ALB using the aws_lb resource.

```terraform
resource "aws_lb" "apploadbalancer" {
  name               = "app-load-balancer"
  load_balancer_type = "application"

  tags               = var.common_tags
}
```

Extras:

TODO:Set-up a listener
TODO:addinstances
