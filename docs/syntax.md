# Terraform HCL syntax Primer

Most of what you need to know ius found on the teTerraform site [https://www.terraform.io/docs/configuration/variables.html](https://www.terraform.io/docs/configuration/variables.html)

## Provisioners

As the Terraform Docs call out **"Provisioners are a Last Resort"**.
Heed these words, there really should be a better way of doing what your trying to do.

Provisoners dont do state, so you have less control over when they run and what they do.
You can use Triggers to control execution. Creating destroy time provisioners is a good way of wasting a lot of your time.

### Connections

Remote Provisoners need authentication, probably via SSH. So you now have an SSH key management issue. You also need to be on a network that allows it. You may have to connect through a bastion host.

### COnnection forwarding

TODO:Thru a Bastion

When to use a Provisioner

- To overcome a bug in Terraform behaviour
- No Terraform resource exists

When not

- Installing on a new instance
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

### Listof

### Sets

### Dynamic

TODO
