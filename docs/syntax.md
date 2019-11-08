# Terraform HCL syntax Primer

Most of what you need to know is found on the Terraform site [https://www.terraform.io/docs/configuration/variables.html](https://www.terraform.io/docs/configuration/variables.html)

## Provisioners

As the Terraform Docs call out **"Provisioners are a Last Resort"**.
Heed these words, there is, and there really should be a better way of doing what your trying to do.

Provisoners dont do state and are a horror to make idempotent, so you have less control over when they run and what they do.
You can use Triggers to control execution. Creating destroy time provisioners is a good way of wasting a lot of your time.
If you find yourself wanting to install packages with at launch with **remote-exec**:

- Is this better something better pre-prepared in Packer - **Almost definitely**
- If Packer is overkill then could this be done with your bootstrap load -**maybe, see previoud answer**.
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

### Variables

- strings
- maps
- lists

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

### Dynamic

TODO
