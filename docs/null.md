# Null

We'll here's something to be really proud of.

```
resource "null_resource" "waiter" {
  depends_on = ["aws_iam_instance_profile.ec2profile"]

  provisioner "local-exec" {
    command = "sleep 15"
  }
}
```
