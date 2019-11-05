# Creating an EC2 Instance

## Make an instance in a public sub-net

Open your shell again and get a new scaffold:

```cli
scaffold aws_instance
```

add **aws_instance.web.tf** to the new scaffold.

```terraform
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  tags = var.common_tags
}
```

Rather than hardcoding the AMI like above, a better and more maintainable way it to get the latest AMI made of that type:
Adding an ami data source is a better way, like this one for ubuntu xenial **data.aws_ami.xenial.tf**:

```terraform
data "aws_ami" "xenial" {
  most_recent      = true
  owners           = ["099720109477"]

  filter {
    name = "name"
    values = ["ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}
```

Then update the AMI reference in aws_instance to:

```terraform
ami           = data.aws_ami.xenial.id
```

If you apply now the latest xenial AMI will start, and as just about every other property isn't specified it will use the defaults for VPC, Subnet and Security Group.

```terraform
 + aws_instance.web
      id:                           <computed>
      ami:                          "ami-01bc69b830b49f729"
      arn:                          <computed>
      associate_public_ip_address:  <computed>
      availability_zone:            <computed>
      cpu_core_count:               <computed>
      cpu_threads_per_core:         <computed>
      ebs_block_device.#:           <computed>
      ephemeral_block_device.#:     <computed>
      get_password_data:            "false"
      host_id:                      <computed>
      instance_state:               <computed>
      instance_type:                "t2.micro"
      ipv6_address_count:           <computed>
      ipv6_addresses.#:             <computed>
      key_name:                     <computed>
      network_interface.#:          <computed>
      network_interface_id:         <computed>
      password_data:                <computed>
      placement_group:              <computed>
      primary_network_interface_id: <computed>
      private_dns:                  <computed>
      private_ip:                   <computed>
      public_dns:                   <computed>
      public_ip:                    <computed>
      root_block_device.#:          <computed>
      security_groups.#:            <computed>
      source_dest_check:            "true"
      subnet_id:                    <computed>
      tags.%:                       "1"
      tags.createdby:               "Terraform"
      tenancy:                      <computed>
      volume_tags.%:                <computed>
      vpc_security_group_ids.#:     <computed>
```

<img src="https://gist.github.com/JamesWoolfenden/7edc471e5fc5a3a47162532bd428d6b2/raw/2285ac1571718e77fcb29b5b6f93baa4f366d6c7/termtosvg_qmdskn5m.svg?sanitize=true">

## Specify an SSH key

The currently provisioned instance has no access as no SSH key was specified, you can manually upload your ssh key to AWS or automatically provision one.

Create an SSH key by adding  **tls_private_key.ssh.tf**

```terraform
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}
```

and add a new provider for tls **provider.tls.tf**:

```terraform
provider tls {
    version="2.1.1"
}
```

Add the generated key to AWS with **aws_key_pair.ssh.tf**

```terraform
resource "aws_key_pair" "ssh" {
  key_name   = "id_rsa"
  public_key = tls_private_key.ssh.public_key_openssh
}
```

To SSH in you'll need the private key, get the key pair with **local_file.ssh-key.tf**:

```terraform
resource "local_file" "pem-private" {
  content  = tls_private_key.ssh.private_key_pem
  filename = "${path.cwd}/id_rsa"
}

resource "local_file" "ssh-public" {
  content  = tls_private_key.ssh.public_key_openssh
  filename = "${path.cwd}/id_rsa.pub"
}
```

This needs a provider for file **provider.local.tf**:

```terraform
provider local {
  version="1.4"
}
```

Update the **aws_instance** resource to link to the new key:

```terraform
resource aws_instance web {
  ami           = data.aws_ami.xenial.id
  instance_type = "t2.micro"
  tags          = var.common_tags
  key_name      = aws_key_pair.ssh.key_name
}
```

And a Secruity group that allows access:

```terraform
resource aws_security_group ssh {
  name = "allow-ssh"

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }

  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}
```

!!! Warning Security
    In the ingress I use a CIDR of "0.0.0.0/0", which is wide open to the world. Id normally restict this my own IP.
    You could also make the Ingress group optional and deprovision it all together at a later date.

and finally add update **outputs.tf** to get the public to get the Public ip to SSH into.

```terraform
output public_ip {
  value=aws_instance.web.public_ip
}
```

Apply the above changes:

<img src="https://gist.github.com/JamesWoolfenden/ebb10ad6247403eda8c53cd5194a69fe/raw/3a96af027a6acb62e2843f689aec97f08293ae43/termtosvg_7pzoqrpc.svg?sanitize=true">

See the created key files **id_rsa** and **id_rsa.pub** and test by SSHing into new instance.

```terraform
$ ls -l
total 32
-rwxrwxrwx 1 jim jim   406 Oct 22 10:13 Makefile
-rwxrwxrwx 1 jim jim  2701 Oct 22 10:13 README.md
-rwxrwxrwx 1 jim jim    46 Oct 22 10:13 aws_instance.auto.tfvars
-rwxrwxrwx 1 jim jim   189 Nov  5 14:15 aws_instance.web.tf
-rwxrwxrwx 1 jim jim   114 Nov  5 14:01 aws_key_pair.ssh.tf
-rwxrwxrwx 1 jim jim   289 Nov  5 14:14 aws_security.ssh.tf
-rwxrwxrwx 1 jim jim   345 Oct 22 10:13 data.aws_ami.xenial.tf
-rwxrwxrwx 1 jim jim  1675 Nov  5 14:23 id_rsa
-rwxrwxrwx 1 jim jim   381 Nov  5 14:23 id_rsa.pub
-rwxrwxrwx 1 jim jim   260 Nov  5 14:01 local_file.ssh-key.tf
-rwxrwxrwx 1 jim jim    35 Oct 22 10:13 main.tf
-rwxrwxrwx 1 jim jim    59 Nov  5 14:21 outputs.tf
-rwxrwxrwx 1 jim jim    68 Nov  5 10:17 provider.aws.tf
-rwxrwxrwx 1 jim jim    38 Nov  5 14:13 provider.local.tf
-rwxrwxrwx 1 jim jim    38 Nov  5 13:57 provider.tls.tf
-rwxrwxrwx 1 jim jim 15355 Nov  5 14:24 terraform.tfstate
-rwxrwxrwx 1 jim jim  5920 Nov  5 14:23 terraform.tfstate.backup
-rwxrwxrwx 1 jim jim    80 Nov  5 13:44 tls_private_key.ssh.tf
-rwxrwxrwx 1 jim jim   120 Oct 22 10:13 variables.tf
```

!!! Warning
    Do not add keys to Git

!!! Info
    Run "Terraform destroy" to cleanup.
