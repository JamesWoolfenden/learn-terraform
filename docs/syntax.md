# Terraform HCL syntax Primer

Most of what you need to know is found on the Terraform site [https://www.terraform.io/docs/configuration/variables.html](https://www.terraform.io/docs/configuration/variables.html). The information provided here is in addition.

## Provisioners

As the Terraform Docs call out **"Provisioners are a Last Resort"**.
Heed these words, there is, and there really should be a better way of doing what your trying to do.

Provisioners don't do state and are a horror to make idempotent, so you have less control over when they run and what they do.
You can use Triggers to control execution, but creating destroy time provisioners is a good way of wasting a lot of your time.

If you find yourself wanting to install packages at launch with **remote-exec** ask yourself:

- Is this something better pre-prepared in Packer - **Almost definitely**
- If Packer is overkill then could this be done with your bootstrap load -**maybe, see previous answer**.
  The Bootstrap load should be the chance to add environment specific configuration at launch-time.
- Remember that Installing at launch is slow and could fail, so if you're spinning up because of a scaling request, you have no time to spare, and have zero room for failure.
- Remember pre-prepared always beats installing.
- With In-place updates there's always a risk of failed update and loss of use while changing, Downtime is to be avoided.

### Connections

Remote Provisioner's need authentication, probably via SSH [God forbid it **winrm**]. So you now have SSH key, password or certificate management issues. You also need to be on a network that allows it. You may have to connect through a bastion host.

### Connection forwarding

TODO:Thru a Bastion

When to use a Provisioner

- To overcome a bug in Terraform behaviour.
- No Terraform resource exists.

When not

- Installing anything on a new instance.
  Terraform is for making infrastructure, and for managing "Cattle". If you find your self wanting to install a lot of components, you should be making new component via tools like Packer.

### Remote-Exec

SSH onto a box after creation.

### Local-exec

Make something/execute on the build box during provisioning.

### File Provisioning

### Triggers

everytime
triggers {
build_number = "\${timestamp()}"
}
when = "destroy"

on create is the default

when = "destroy"

TODO
on_failure = "continue"

!!!Note Other Provisioners
    I have never used these provisioners, if you have some legacy scripts you want to exploit they may have be useful.
    Chef provisioner

    Puppet provisioner

    Habitat provisioner

    Salt-masterless Provisioner

## Resources

This is the main component class in Terraform, resource are the infrastructure objects you're trying to create.

## Providers

### Passing Provider to Module

How do I pass the provider and its configuration into a module?

The default provider is passed in without you seeing anything, but a non default or extra one is very different.

- define a Provider **provider.secondary.tf**

```terraform
provider "aws" {
  alias   = "secondary"
  region  = "us-east-1"
  version = "2.35.0"
}
```

and then pass it in the module definition **module.stuff.tf**

```terraform
module "stuff" {
...
providers = {
    aws = "aws.secondary"
  }
}
```

Easy enough.

### Passing multiple providers

What happens if you need to pass 2 different defined providers?

Then define one as the default, and one with a named alias and pass them to the module.

```terraform
module "cassandra" {
  source        = "../../"
  instance_type = var.instance_type
  common_tags   = var.common_tags
  providers = {
    aws=aws
    aws.secondary = "aws.useast"
  }
}
```

And then you can try and reference the providers:

```terraform
resource "aws_instance" "remote-cassandra-node3" {
  provider      = aws.secondary
  key_name      = element(module.ssh-key-secondary.keys, 0)
  ami           = data.aws_ami.ubuntu-secondary.image_id
  instance_type = var.instance_type

  root_block_device {
    volume_type           = "standard"
    volume_size           = 100
    delete_on_termination = false
  }

  tags = var.common_tags
}
```

Now I almost thought it could just be that easy, but when you plan/apply you get:

!!! error
    Error: missing provider module.cassandra.provider.aws.secondary

The answer is to create an empty Provider in your module **provider.secondary.tf** and your golden:

```terraform
provider "aws" {
  alias="secondary"
}
```

!!!Note
    Samples from the module <https://github.com/JamesWoolfenden/terraform-aws-cassandra>

### Functions

Are well covered here [https://www.terraform.io/docs/configuration/functions.html](https://www.terraform.io/docs/configuration/functions.html)

### Variables

- strings
- maps
- lists

- null
  passing
  blocks
  lists

- locals
  Terraform doesn't support interpolation of variables in variables.

So although it would be **AWESOME** if this worked:

```terraform
variable "name" {
  default="James"
}

variable "fullname" {
  default="${var.name} Woolfenden"
}
```

It however does not. Coff.

However something similar can be achieved with **locals**:

```terraform
variable "name" {
  default="James"
}

locals {
  fullname="${var.name} Woolfenden"
}
```

To reference the local you use:

_local.fullname_ instead of _var.fullname_

See the Terraform docs [here](https://www.terraform.io/docs/configuration/locals.html)

## Outputs

I use an **Outputs.tf** in my templates and modules, it helps with re-use and extensibility if you pass out complex data objects to your output.
This is now valid:

```terraform
output "function" {
    value= google_cloudfunctions_function.lambda
}
```

## new in TF 0.12

## Listof

todo

### Objects

You can define lists of a type or multiple types.

```terraform
  type        = list(map(string))
```

or

```terraform
variable "database" {
  type=list(object({
    name = string
  }))
  default=[]
}
```

Setting the database variable:

```HCL
database=[{
        name= "my-database"
    },
    {
        name= "your-database"
    }]
```

When used with **google_sql_database.database.tf** it will create 2 databases.

```terraform
resource "google_sql_database" "database" {
  count    = length(var.database)
  name     = var.database[count.index]["name"]
  instance = google_sql_database_instance.instance.name
}
```

This syntax enables optional creation of resources based on that object being populated, or not.

### Sets

todo

### Dynamic

The Dynamic keyword can be used to variable length blocks as used in this [codepipeline](https://github.com/JamesWoolfenden/terraform-aws-codepipeline/blob/master/aws_pipeline.pipe.tf) module.

```terraform
dynamic "stage" {
  for_each = [for s in var.stages : {
    name   = s.name
    action = s.action
  }]

  content {
    name = stage.value.name
    action {
      name             = stage.value.action["name"]
      owner            = stage.value.action["owner"]
      version          = stage.value.action["version"]
      category         = stage.value.action["category"]
      provider         = stage.value.action["provider"]
      input_artifacts  = stage.value.action["input_artifacts"]
      output_artifacts = stage.value.action["output_artifacts"]
      configuration    = stage.value.action["configuration"]
    }
  }
}
```

## Order

One of the awesome things that Terraform normally just does correctly, nearly always. Sometimes it doesn't and usually thats poor design on out part, but sometimes not.

### depends_on

You can set the **depends_on** keyword on a resource to force a dependency, it shouldn't be needed.

```terraform
resource "aws_instance" "web" {
  depends_on = [aws.aws_iam_instance_profile.stuff]

  # ...
}
```

I have had to use this in the past on objects, and while the provider said they were created, they were actually still in the process of being created, and being replicated across regions on their way to being consistent.

### depends_on with modules

Depends_on became a keyword with Terraform 0.12, you can achieve the same with 0.12.

```terraform
variable "vm_depends_on" {
  type    = any
  default = null
}

resource "aws_instance" "web" {
  depends_on = [var.vm_depends_on]

  # ...
}
```

If the file above becomes part of a module:

```terraform
module "web" {
  source = "..."

  vm_depends_on = [module.anyobject.youchoose]
}
```

!!!Note
     After <https://discuss.hashicorp.com/t/tips-howto-implement-module-depends-on-emulation/2305/2>
