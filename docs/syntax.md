# Terraform HCL syntax Primer

Most of what you need to know is found on the Terraform site [https://www.terraform.io/docs/configuration/variables.html](https://www.terraform.io/docs/configuration/variables.html)

## Provisioners

As the Terraform Docs call out **"Provisioners are a Last Resort"**.
Heed these words, there is, and there really should be a better way of doing what your trying to do.

Provisoners dont do state and are a horror to make idempotent, so you have less control over when they run and what they do.
You can use Triggers to control execution. Creating destroy time provisioners is a good way of wasting a lot of your time.
If you find yourself wanting to install packages with at launch with **remote-exec**:

- Is this better something better pre-prepared in Packer - **Almost definitely**
- If Packer is overkill then could this be done with your bootstrap load -**maybe, see previous answer**.
- Installing at Launch is slow, if you spinning up because of a scaling request, you have no time to spare.
The Bootstrap load should be the chance to add environment specifc configuration at launchtime.

### Connections

Remote Provisoners need authentication, probably via SSH{god forbid it winrm}. So you now have an SSH key management issue. You also need to be on a network that allows it. You may have to connect through a bastion host.

### Connection forwarding

TODO:Thru a Bastion

When to use a Provisioner

- To overcome a bug in Terraform behaviour
- No Terraform resource exists

When not

- Installing anything on a new instance
  Terraform is for making infrastructure and for managing "Cattle". If you find your self wanting to install a lot of components you should be making new components via tools like Packer.

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

    Salt-masterless Provioner

## Resources

This is the main component class in Terraform, resource are the infrastructure objects you're trying to create.

### Providers

Multiple use
todo

Passing to Modules
todo

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

*local.fullname* instead of *var.fullname*

See the Terraform docs [here](https://www.terraform.io/docs/configuration/locals.html)

## new in TF 0.12

## Listof

### Objects

You can define lists of a type or multiple types.

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

### depends_on with modules
