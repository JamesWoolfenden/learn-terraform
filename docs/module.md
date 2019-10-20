# Creating and using a Terraform module

So far all the examples you have made are Terraform templates/Layers, that is, environmental specific implementations.

After a short time writing Terraform you'll realise that you can save time and effort by re-using parts of your own code or by using field tested code of others.

Terraform can be written for re-use by defining your code as a module. Modules describe a model of infrastructure but without any environment specific information.

## Terraform Modules

Principles for module creation:

- designed for re-use.
- environental agnostic.
- has utility not found in resources, - must add something.
- uses sensible defaults.
- enables overrides for defaults.
- includes a readme with usage
- conforms to the standard module structure layout
<https://www.terraform.io/docs/modules/index.html>
- versioning of modules.
- contains examples.
- defines inputs in variables.tf with descriptions.
- defines outputs in outputs.tf with descriptions.
- one module, one repository.

And if public:

- A LICENSE.TXT

## Referencing and Versioning

If you consume a module it's important that you target a Version, otherwise you can expose yourself to unexpected changes and failures. The version you consume can be defined in 2 main ways:

To use a module you need to reference its source.
**module.s3.tf**

### Local references

You would use these if you were nesting modules in your folder structure or if you are developing the modules yourself.

```terraform
module "S3" {
    source="../../terraform-aws-s3/"
}
```

### Git references

You can refer to your git in your modules source, this will always get the Head revision of the default branch - Master usually.

```terraform
module "S3" {
    source="git::git@github.com:JamesWoolfenden/terraform-aws-s3.git"
}
```

You can use the Git CLI, to tag your modules, when inside the Repository at the CLI/console:

```bash
git tag -a "0.0.1" -m "Initial commit"
git push --follow-tags
```
Or have your own CI process for your modules.
You need to tag and then push the tag to the upstream repository.

### tip

You can also set your git config to always follow tags:

```cli
git config --global push.followTags true
```

With the tags set and  pushed, you can now set the source reference to link to the tag:

```terraform
module "S3" {
    source="git::git@github.com:JamesWoolfenden/terraform-aws-s3.git?ref=0.0.1"
}
```

### Github reference

Terraform is smart enough to infer some of the source if it starts with github.

```terraform
module "S3" {
    source="github.com/JamesWoolfenden/terraform-aws-s3"
}
```

- Terrafom registry
This is the next level up, defining and publishing your module to the Public Terraform registry.

I use Semantic version for my public modules, and every buildable module gets a tag at the end of its build, in this case the module release I want is 0.0.5:

```terraform
module "S3" {
    source="jameswoolfenden/s3/aws"
    version="0.0.5"
}
```

There are a number of other less common ways to reference your source <https://www.terraform.io/docs/modules/sources.html>

## Testing your modules

Terraform lacks an established/comprehensive unit testing framework. There are some efforts in this area:
<https://github.com/gruntwork-io/terratest>

### Enforcing fmt

I use tf_scaffold to create new modules and this always adds a pre-commit file. This fails the commit if Terraform fmt fails, other Terraform hooks also exist.

### Test/reference implementation

I have a build/intregration test that builds and destroys one of my modules examples before it tags the module.

### Creating a simple module

- Create a scaffold
tf scaffold terraform-aws-s3

- add s3 resource
- update variables.tf
- update outputs.tf
- add example
- test example
- add readme
- Add to a new git repo and push

### Tip for extra credit

- Connect up your Github account with the Terraform registry
- select a repository and publish
- add build to gitlab/travis/circleci ...
