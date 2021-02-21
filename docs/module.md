# Creating and using a Terraform module

So far all the examples you have made are Terraform templates/Layers, that is, environmental specific implementations.

After a short time writing Terraform you'll realise that you can save time and effort by re-using parts of your own code or by using field tested code of others.

Terraform can be written for re-use by defining your code as a module. Modules describe a model of infrastructure but without any environment specific information.

## Terraform Modules

Principles for module creation:

- designed for re-use.
- environmental agnostic.
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

!!! note "Git and tags"
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

### Terraform registry

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

I have a build/integration test that builds and destroys one of my modules examples before it tags the module. I am currently using Travis for building, testing and labelling my modules, other CI tools would also work <https://github.com/JamesWoolfenden/terraform-gcp-bastion/blob/master/.travis.yml>

```yaml
dist: trusty
sudo: required
services:
  - docker
branches:
  only:
    - master

env:
  - VERSION="0.1.$TRAVIS_BUILD_NUMBER"

addons:
  apt:
    packages:
      - git
      - curl

before_script:
  - export TERRAFORM_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')
  - curl --silent --output terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
  - unzip terraform.zip ; rm -f terraform.zip; chmod +x terraform
  - mkdir -p ${HOME}/bin ; export PATH=${PATH}:${HOME}/bin; mv terraform ${HOME}/bin/
  - terraform -v

script:
  - terraform init -get-plugins -backend=false -input=false
  - terraform init -get -backend=false -input=false
  - terraform fmt
  - bash validate.sh

after_success:
  - git config --global user.email "builds@travis-ci.com"
  - git config --global user.name "Travis CI"
  - export GIT_TAG=$VERSION
  - git tag $GIT_TAG -a -m "Generated tag from TravisCI build $VERSION"
  - git push --quiet https://$TAGAUTH@github.com/jameswoolfenden/terraform-gcp-bastion $GIT_TAG > /dev/null 2>&
```

### Scaffold

Add a function to your profile to add a function to your shell. That's \$PROFILE on Windows or ~/.bashrc on Linix.

```powershell fct_label="powershell"
function scaffold {
   param(
      [parameter(mandatory=$true)]
      [string]$name)

   if (!(test-path .\$name))
   {
      git clone --depth=1 git@github.com:JamesWoolfenden/tf-scaffold.git "$name"
   }
   else{
      write-warning "Path $name already exists"
      return
   }

   rm "$name\.git" -recurse -force
   cd $name
   git init|git add -A
}
```

```bash fct_label="bash"
function scaffold() {
if [ -z "$1" ]
then
   name="scaffold"
else
   name=$1
fi

if [ -z "$2" ]
then
   branch="master"
else
   branch=$2
fi


echo "git clone --depth=1 --branch $branch git@github.com:JamesWoolfenden/tf-scaffold.git $name"
git clone --depth=1 --branch $branch git@github.com:JamesWoolfenden/tf-scaffold.git $name
rm $name/.git -rf
}
```

## Making a module

### Deploy a Scaffold

In your shell:

```shell
$ scaffold terraform-aws-s3
Cloning into 'terraform-aws-s3'...
remote: Enumerating objects: 14, done.
remote: Counting objects: 100% (14/14), done.
remote: Compressing objects: 100% (8/8), done.
remote: Total 14 (delta 0), reused 8 (delta 0), pack-reused 0
Receiving objects: 100% (14/14), done.
```

### Enable the pre-commit

Pre-commit needs to be installed just the one time, following their instructions [Pre-commit](https://pre-commit.com/)

```python
pip install pre-commit
```

The **.pre-commit.config.yaml** in the root:

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v2.1.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
  - repo: git://github.com/Lucas-C/pre-commit-hooks
    rev: v1.1.6
    hooks:
      - id: forbid-tabs
        exclude_types: [python, javascript, dtd, markdown, makefile]
        exclude: binary|\.bin$
  - repo: git://github.com/kintoandar/pre-commit.git
    rev: v2.1.0
    hooks:
      - id: terraform_fmt
  - repo: https://github.com/pre-commit/pre-commit-hooks.git
    rev: v2.1.0

    hooks:
      - id: detect-aws-credentials
      - id: detect-private-key
  - repo: https://github.com/detailyang/pre-commit-shell
    rev: 1.0.4
    hooks:
      - id: shell-lint
  - repo: git://github.com/igorshubovych/markdownlint-cli
    rev: v0.14.0
    hooks:
      - id: markdownlint
```

In the root of **terraform-aws-s3**:

```shell
pre-commit install
```

Now any edits and the subsequent commits will trigger the hook.

### Add an aws_s3_bucket resource

Add the following as **aws_s3_bucket.bucket.tf**

```terraform
resource "aws_s3_bucket" "bucket" {
  bucket        = var.s3_bucket_name
  policy        = var.s3_bucket_policy
  acl           = var.s3_bucket_acl
  force_destroy = var.s3_bucket_force_destroy

  tags = var.common_tags
}
```

### Update **variables.tf**

```terraform

variable "common_tags" {
  description = "This is a map type for applying tags on resources"
  type        = map
}

variable "s3_bucket_name" {
  description = "The name of the bucket"
  type        = string
}

variable "s3_bucket_force_destroy" {
  description = "String Boolean to set bucket to be undeletable (well more difficult anyway)"
  type        = string
}

variable "s3_bucket_acl" {
  default     = "private"
  description = "Acl on the bucket"
  type        = string
}

variable "s3_bucket_policy" {
  description = "The IAM policy for the bucket"
  type        = string
}

locals {
  env = substr(var.common_tags["environment"], 0, 1)
}
```

### Update **outputs.tf**

```terraform
output s3_id {
  value       = aws_s3_bucket.bucket.id
  description = "The id of the bucket"
}

output bucket_domain_name {
  value       = aws_s3_bucket.bucket.bucket_domain_name
  description = "The full domain name of the bucket"
}

output account_id {
  value       = data.aws_caller_identity.current.account_id
  description = "The AWS account number in use"
}
```

### Add example

The example serves 2 purposes, as a test and as a reference implementation.

In the root, add a folder **example/exampleA**
In there you'll need a **provider.aws.tf**

```terraform
provider "aws" {
  version = "3.11.0"
}
```

and a **module.S3.tf**

```terraform
module "S3" {
    source="../../terraform-aws-s3/"
}
```

### Test example

init

apply

### Add a readme

Add in a file called README.md into the root.

### Add to a new git repo and push

Add all the contents to your new repository you created. There is a naming format for [Registries](https://www.terraform.io/docs/registry/modules/publish.html).

!!!Note Extra credit

    - Publish and make it public, [see standard structure](https://www.terraform.io/docs/modules/#standard-module-structure)

    - Connect up your Github account with the Terraform registry

    - Select a repository and publish

    - Add build to Gitlab/Travis/Circleci

    - Tag it

    - [Advanced Module composition](https://www.terraform.io/docs/modules/composition.html)
