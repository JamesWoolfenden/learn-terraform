# Learn Terraform

[![Latest Release](https://img.shields.io/github/v/tag/slalom-consulting-ltd/learn-terraform.svg)](https://github.com/JamesWoolfenden/learn-terraform-web)

By [James Woolfenden](https://www.linkedin.com/in/jameswoolfenden/)

## What is Terraform

Terraform is a language and tool for creating infrastructure via a technique called Infrastructure as Code.
This is an example of an AWS instance, know as a resource, called "web" described in Terraform with 4 properties set:

```terraform
resource "aws_instance" "web" {
  ami           = data.aws_ami.xenial.id
  instance_type = "t2.micro"
  tags          = var.common_tags
  key_name      = aws_key_pair.ssh.key_name
}
```

### What it means

The first line starts with **Resource** this declares the type of object, in this case a resource, alternatives include module, data or variable.

"aws_instance" is the type of resource, in this case an instance or EC2 Virtual Machine.
"web" this is the object name, the name this is up to you, the brackets are a fairly normal declaration of an object, but the opening must start on the first line.

```ami           = data.aws_ami.xenial.id```

The property ami is set to  *data.aws_ami.xenial.id*, *data* means its a data resource, of type *aws_ami* that's been called xenial and supply the property *id*.

``` instance_type="t2.micro"```

The property *instance_type* has been hard-coded to the string value.

```tags          = var.common_tags```

The tags property has been set to *var.common_tags* which is a declared variable called common_tags.

When Terraform is run it will check and create the resource if not existing already. If it's different it will fix the drift in the object to look like the specification.

The Terraform tool is written in Go-lang, and available for many platforms as a single executable binary, you can find the source is hosted on Github here:
[Terraform](https://github.com/hashicorp/terraform), it is being actively developed and there are very regular updates to its core [changelog](https://github.com/hashicorp/terraform/blob/master/CHANGELOG.md)
and to it's [providers](https://github.com/terraform-providers):
[AWS](https://github.com/terraform-providers/terraform-provider-aws) and it's
[changelog](https://github.com/terraform-providers/terraform-provider-aws/blob/master/CHANGELOG.md)
or
[GCP](https://github.com/terraform-providers/terraform-provider-google) and its
[changelog](https://github.com/terraform-providers/terraform-provider-google/blob/master/CHANGELOG.md)

This chapter focuses on how to use the free edition features in the Open source tool and Terraform Cloud.
Unless called out, all AWS infrastructure will be provisioned in just one AWS region.

## Rationale

Terraform is a second generation DevOps tool, it is designed to help you provision infrastructure.
Templates are designed in Hashicorp Configuration Language (HCL) to describe how your infrastructure should be, and can be used to create and model your infrastrucuture, as well as being part of your Configuration Management Toolchain.

## Alternatives

In no particular order:

### [Puppet](https://puppet.com/) and [Chef](https://www.chef.io/)

These are the old guard or the v1.0 CM Tools, lots of agents and lots of set-up.

### [Ansible](https://www.ansible.com/)

No Servers and No Agents. A very useful tool for configuration and in combination with Packer and Terraform.

### [CloudFoundry](https://www.cloudfoundry.org/)

### [Salt Stack](https://www.saltstack.com/)

More popular the otherside of the Atlantic, very rare in London/SE.

### Cloudformation

Popular with some AWS Consultants.

### [Pulumi](https://www.pulumi.com/)

If you want to code your infrastructure in a language you already know, this is for you, with support for Python and JS. Great for small teams with no specialised infra experience and if you can't get your head around the declarative approach of Terraform, this ones for you.

### Your own scripts

Probably won't makes sense to even you six months later, god forbid you have use someone elses or they yours.

### The Console

Well that's not DevOps is it.
