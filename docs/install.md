# Installing

Terraform is available from the popular platform package managers for Macs and Windows.

```mac
brew install terraform
```

```Powershell
cinst Terraform
```

```shell
export TERRAFORM_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')
curl --silent --output terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
unzip terraform.zip ; rm -f terraform.zip; chmod +x terraform
mkdir -p ${HOME}/bin ; export PATH=${PATH}:${HOME}/bin; mv terraform ${HOME}/bin/
terraform -v
```

You'll need to update your path to pick up the exe on Windows.

There's still no official package manager support on Linux <https://github.com/hashicorp/terraform/issues/17794>, so it's just the binaries and getting them in your path.

Verify you have Terraform set-up with:

```cli
$ terraform --version
Terraform v0.12.20
```

Now we have Terraform now installed, the next step is to try running it. To do any useful work, this would be against and using a Cloud provider, [e.g. AWS] and for that we require Authentication.

## Authentication

### Basic Authentication with the AWS Provider

Install the AWS Cli and add your Key and Secret.You can also use the new Cli too <https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html>.

```mac fct_label="mac"
brew install aws-cli
```

```powershell fct_label="Powershell"
cinst aws-cli
```

Verify that with:

```cli
$ aws --version
aws-cli/1.16.303 Python/3.6.0 Windows/10 botocore/1.13.39
```

You will either be supplied you Cli credentials by your AWS administrator or you can obtain your own from your own user IAM section.

```cli
$ aws configure
AWS Access Key ID [********************]:
AWS Secret Access Key [********************]:
Default region name [eu-west-1]:
Default output format [json]:
```

There are many more way to provide AWS Authentication than just this.
Old examples may show the hard-coding of secrets or the use of vars to then pass them in. Do not.

```aws
provider "aws" {
  region     = "eu-west-1"
  access_key = "givemymoneyaway"
  secret_key = "to-bitcoin-miners"
}
```

Open the sub-folder **basic-aws-auth** in your console. Validate your authentation set-up by executing **terraform init** and then **terraform apply**:

<img src="https://gist.github.com/JamesWoolfenden/be86879e4e549c74e2278f10f044cd81/raw/956b0cb08c91157bbe2e0db571110c36212a9a1c/termtosvg_ej_gax9u.svg?sanitize=true">

### with the GCP Provider

Basic auth with GCP is pretty similar, create a service account in your GCP project, create a key file and download into your profile, create an environmental variable that points to it e.g. :

```cli
export GOOGLE_CLOUD_KEYFILE_JSON={{path}}
```

Open **basic-gcp-auth** in your console, and update your **provider.gcp.tf** to have the name of your project.

```cli
provider "google" {
  project     = "examplea"
  region      = "us-central1"
  version     = "2.17"
}
```

Run Terraform init and then apply:

<img src="https://gist.github.com/JamesWoolfenden/0fe27979ed83032b615cd692daeb92b0/raw/14da990b514fb6443f2156058ec9246084107431/termtosvg_phzb64eq.svg?sanitize=true">

You now have your GCP auth set-up.

!!! note "Tip - Create a GCP project called **examplea**"
All the GCP examples are based around a project called examplea.
Instead of updating your providers, save yourself some time and create yourself a project called examplea.

## Terraform commands

Terraform is a command line tool, to see its usage, just Type Terraform at your console now.

```shell
$ terraform
Usage: terraform [-version] [-help] <command> [args]

The available commands for execution are listed below.
The most common, useful commands are shown first, followed by
less common or more advanced commands. If you're just getting
started with Terraform, stick with the common commands. For the
other commands, please read the help and docs before usage.

Common commands:
    apply              Builds or changes infrastructure
    console            Interactive console for Terraform interpolations
    destroy            Destroy Terraform-managed infrastructure
    env                Workspace management
    fmt                Rewrites config files to canonical format
    get                Download and install modules for the configuration
    graph              Create a visual graph of Terraform resources
    import             Import existing infrastructure into Terraform
    init               Initialize a Terraform working directory
    output             Read an output from a state file
    plan               Generate and show an execution plan
    providers          Prints a tree of the providers used in the configuration
    push               Upload this Terraform module to Atlas to run
    refresh            Update local state file against real resources
    show               Inspect Terraform state or plan
    taint              Manually mark a resource for recreation
    untaint            Manually unmark a resource as tainted
    validate           Validates the Terraform files
    version            Prints the Terraform version
    workspace          Workspace management

All other commands:
    debug              Debug output management (experimental)
    force-unlock       Manually unlock the terraform state
    state              Advanced state management
```

That's a lot of commands, however there are only handful of actually common commands that you really use, 90% of the time it is an just Terraform and:

### Init

This command sets up the project, gets providers and connects any defined back-ends.

```cli
terraform init

Initializing the backend...

Initializing provider plugins...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Terraform init can be thought of an equivalent to git init, it downloads the provider executable, modules and does an initial syntax check, all into a **.terraform** folder.

For the full description its:

```cli
terraform init --help
```

if you open a **.terraform** folder you find

```shell
$ ls -l
total 0
drwxrwxrwx 1 jim jim 512 Nov  4 23:00 modules
drwxrwxrwx 1 jim jim 512 Nov  4 22:18 plugins
```

The modules folder hold a copy of the terraform modules that you are using.
The plugins hold the downloaded copies of the executable providers.

### Plan

What would happen on an Apply. The command is a hangover from older versions of Terraform, the apply command now includes a plan stage by default.

```cli
$ terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_vpc.main will be created
  + resource "aws_vpc" "main" {
      + arn                              = (known after apply)
      + assign_generated_ipv6_cidr_block = false
      + cidr_block                       = "10.0.0.0/16"
      + default_network_acl_id           = (known after apply)
      + default_route_table_id           = (known after apply)
      + default_security_group_id        = (known after apply)
      + dhcp_options_id                  = (known after apply)
      + enable_classiclink               = (known after apply)
      + enable_classiclink_dns_support   = (known after apply)
      + enable_dns_hostnames             = (known after apply)
      + enable_dns_support               = true
      + id                               = (known after apply)
      + instance_tenancy                 = "default"
      + ipv6_association_id              = (known after apply)
      + ipv6_cidr_block                  = (known after apply)
      + main_route_table_id              = (known after apply)
      + owner_id                         = (known after apply)
      + tags                             = {
          + "createdby" = "Terraform"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```

### Apply

The actual doing. This can create and destroy, infrastructure will be modified to follow your definitions and compared to your state.

```cli
terraform apply

An execution plan  has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_vpc.main will be created
  + resource "aws_vpc" "main" {
      + arn                              = (known after apply)
      + assign_generated_ipv6_cidr_block = false
      + cidr_block                       = "10.0.0.0/16"
      + default_network_acl_id           = (known after apply)
      + default_route_table_id           = (known after apply)
      + default_security_group_id        = (known after apply)
      + dhcp_options_id                  = (known after apply)
      + enable_classiclink               = (known after apply)
      + enable_classiclink_dns_support   = (known after apply)
      + enable_dns_hostnames             = (known after apply)
      + enable_dns_support               = true
      + id                               = (known after apply)
      + instance_tenancy                 = "default"
      + ipv6_association_id              = (known after apply)
      + ipv6_cidr_block                  = (known after apply)
      + main_route_table_id              = (known after apply)
      + owner_id                         = (known after apply)
      + tags                             = {
          + "createdby" = "Terraform"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:

```

### Targeted Apply

With a Targeted Apply you can cherry pick the apply, this is especially useful when were developing or debugging:

```bash
terraform apply --target aws_vpc.main
```

This command will only make the VPC, and any of its dependant objects.

### Destroy

What does it destroy, the definition or the state reference?

```cli
$ terraform destroy
...
```

### Taint

To force the recreation of an object you can taint it, to force it to be changed even if there's no drift.

```bash
terraform taint aws_instance.web
```

### Targeting

It can be very useful to just target one resource at a time, in the previous example just one resource was tainted and a similar method can be used with apply:

```terraform
terraform apply --target module.webbfarm.aws_instance.web
```

Which would only target **module.webbfarm.aws_instance.web** and **ITS' DEPENDENCIES**.

## Modifying existing infrastructure

If the definition differs from the existing state captured. Some properties changing causes existing objects to be modified others the recreation.

How can I tell what which will happen?

TODO:show where changes/destroyed

And usually in this order.

!!!Note "Speeding up your Terraform builds and development"

    When you use Terraform The first step and command in the **Terraform init** this process cuases the appropriate provider executables to be downloaded.
    When you have multiple Terraform projects and environments, that can end up being a lot of copying and downloading, even if you don't **terraform init** that often. A better way is to set up and use a provider cache.

    ### Setting up a Windows plug-in cache

    ```powershell fct_label="powershell"
    ni $env:APPDATA\terraform.rc
    Add-Content $env:APPDATA\terraform.rc "plugin_cache_dir   = `"$HOME\\.terraform.d\\plugin-cache`""
    mkdir "$HOME/.terraform.d/plugin-cache"
    ```

    ```shell fct_label="*nix"
    touch ~/.terraformrc
    echo plugin_cache_dir = \"$HOME/.terraform.d/plugin-cache\" >> ~/.terraformrc
    mkdir "$HOME/.terraform.d/plugin-cache"
    ```

!!!Note Extras
[WSL Windows sub-system for Linux](https://docs.microsoft.com/en-us/windows/wsl/wsl2-index)

    [How to set up WSL](https://docs.microsoft.com/en-us/windows/wsl/wsl2-install)
