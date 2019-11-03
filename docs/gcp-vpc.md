# Creating a Virtual Private Cloud

## Creating an GCP VPC

Creating A VPC with Terraform is fairly straight forward.
A minimal functional example configuration is just:

```terraform
resource "google_compute_network" "vpc_network" {
  name = "lovelyhorse"
}
```

Clone the terraform scaffold into **aws_vpc**.

```cli
$ scaffold aws_vpc --provider GCP
...
```

Add this file **google_compute_network.vpc_network.tf** to the a scaffold in gcp_vpc.
This is example only requires a name.

Open your shell at **./gcp_vpc** and check the configuration with:

```cli
$ terraform init
Initializing the backend...

Initializing provider plugins...

Terraform has been successfully initialized!

```

and then

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

  # google_compute_network.vpc_network will be created
  + resource "google_compute_network" "vpc_network" {
      + auto_create_subnetworks         = true
      + delete_default_routes_on_create = false
      + gateway_ipv4                    = (known after apply)
      + id                              = (known after apply)
      + name                            = "LovelyHorse"
      + project                         = (known after apply)
      + routing_mode                    = (known after apply)
      + self_link                       = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```

If your plan looks like above then you can proceed with terraform apply, by default this now repeats a plan first and then asks you if you want to proceed:

```Terraform

```

Now you have a VPC, and not much else.

Open up the GCP console vpc page:

TODO:addlink

TODO:modify

Now rerun and verify the desired state.

```terraform
$ terraform plan
gcp out
```

The plan tells us that there is 1 more tags on the infrastructure than in our TF "desired state".
We have a choice, enforce the desired state or update the state.

```cli
$ Terraform apply
...
```

Eliminates the drift so there is only 1 tag.

Now that we are done with the example we should tidy up and remove what's provisioned. This is straight forward enough, when your finished with this VPC run:

```terraform
$ terraform destroy
gcp out
```

Then enter yes

```terraform
gcpout
```

Now were back to the clean slate we started with.

So to recap, we made a VPC, checked for drift, fixed the drift and then cleanuped our environment by destroying all our providisoned infrastructure.

## Scaffold revisited

Along with the structure for the template a couple of other files arrived. These are useful if you are going to turn the folder into a git repository.

### .gitignore

This contains a minimal gitignore with Terraform customisations.

### .pre-commit-config.yaml

The is the config file to support the pre-commit framework, it can help enforce good repository security and health. This config contains rules to protect your secrets.

```json

```

### Makefile

Also is a default Makefile for running Terraform

```Makefile
#Makefile

.PHONY: all

all: init plan build

init:
	rm -rf .terraform/modules/
	terraform init -reconfigure

plan: init
	terraform plan -refresh=true

build: init
	terraform apply -auto-approve

check: init
	terraform plan -detailed-exitcode

destroy: init
	terraform destroy -force

docs:
	terraform-docs md . > README.md

valid:
	tflint
	terraform fmt -check=true -diff=true

```

If you plan to turn this folder into a repo you need to install the config (at the root of the repo)
with:

```shell
$ pre-commit install
pre-commit installed at .\.git\hooks\pre-commit
```

Link:

Tf-scaffold <https://github.com/JamesWoolfenden/tf-scaffold>

Yes that wasn't very hard, creating a VPC in GCP is significantly easier than in other the Cloud providers.
