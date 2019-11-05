# Creating a Virtual Private Cloud

## Creating an Amazon VPC

Creating A VPC with Terraform is fairly straight forward.
A minimal functional example configuration is just:

```terraform
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  tags             = var.common_tags
}
```

Clone the terraform scaffold into **aws_vpc**.

```cli
$ scaffold aws_vpc
...
```

Add this file **aws_vpc.main.tf** to the a scaffold in aws_vpc.

The only variable set, is your CIDR block, 10.0.0.0/16. 10.0.0.0/16 is a large range of ip addresses, it is more than adequate at 65536 IP addresses.
<https://www.ipaddressguide.com/cidr>.

Add the following environmental variables to your shell, replacing < yourregion > and either specify a profile or leave it as default.

```shell
AWS_REGION="<yourregion>"
AWS_PROFILE=default
```

Check the configuration with

```cli
$ terraform init
...
```

and then open your shell at **./aws_vpc**:

```cli
$ terraform plan
...
```

```terraform
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:
 + aws_vpc.main
      id:                               <computed>
      arn:                              <computed>
      assign_generated_ipv6_cidr_block: "false"
      cidr_block:                       "10.0.0.0/16"
      default_network_acl_id:           <computed>
      default_route_table_id:           <computed>
      default_security_group_id:        <computed>
      dhcp_options_id:                  <computed>
      enable_classiclink:               <computed>
      enable_classiclink_dns_support:   <computed>
      enable_dns_hostnames:             <computed>
      enable_dns_support:               "true"
      instance_tenancy:                 "default"
      ipv6_association_id:              <computed>
      ipv6_cidr_block:                  <computed>
      main_route_table_id:              <computed>
      owner_id:                         <computed>
      tags.%:                           "1"
      tags.createdby:                   "Terraform"

Plan: 1 to add, 0 to change, 0 to destroy.
```

If your plan looks like above then you can process with terraform apply,
by default this now repeats a plan first and then asks you if you want to proceed:

```Terraform
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  + aws_vpc.main
      id:                               <computed>
      arn:                              <computed>
      assign_generated_ipv6_cidr_block: "false"
      cidr_block:                       "10.0.0.0/16"
      default_network_acl_id:           <computed>
      default_route_table_id:           <computed>
      default_security_group_id:        <computed>
      dhcp_options_id:                  <computed>
      enable_classiclink:               <computed>
      enable_classiclink_dns_support:   <computed>
      enable_dns_hostnames:             <computed>
      enable_dns_support:               "true"
      instance_tenancy:                 "dedicated"
      ipv6_association_id:              <computed>
      ipv6_cidr_block:                  <computed>
      main_route_table_id:              <computed>
      owner_id:                         <computed>
      tags.%:                           "1"
      tags.Name:                        "Terraform"


Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:

Enter yes if you want to make the VPC.

  Enter a value: yes

aws_vpc.main: Creating...
  arn:                              "" => "<computed>"
  assign_generated_ipv6_cidr_block: "" => "false"
  cidr_block:                       "" => "10.0.0.0/16"
  default_network_acl_id:           "" => "<computed>"
  default_route_table_id:           "" => "<computed>"
  default_security_group_id:        "" => "<computed>"
  dhcp_options_id:                  "" => "<computed>"
  enable_classiclink:               "" => "<computed>"
  enable_classiclink_dns_support:   "" => "<computed>"
  enable_dns_hostnames:             "" => "<computed>"
  enable_dns_support:               "" => "true"
  instance_tenancy:                 "" => "dedicated"
  ipv6_association_id:              "" => "<computed>"
  ipv6_cidr_block:                  "" => "<computed>"
  main_route_table_id:              "" => "<computed>"
  owner_id:                         "" => "<computed>"
  tags.%:                           "" => "1"
  tags.Name:                        "" => "Terraform"
aws_vpc.main: Creation complete after 4s (ID: vpc-0382578ed3cd51dcc)

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

Now you have a VPC, and not much else.

Open up the AWS console vpc page:

<https://eu-west-1.console.aws.amazon.com/vpc/home?region=eu-west-1#vpcs:sort=VpcId>

Add key createby with a value - your full name.

Now rerun and verify the desired state.

```terraform
$ terraform plan
aws_vpc.main: Refreshing state... (ID: vpc-0382578ed3cd51dcc)

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  ~ aws_vpc.main
      tags.%:         "2" => "1"
      tags.createdby: "JamesWoolfenden" => ""


Plan: 0 to add, 1 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
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
aws_vpc.main: Refreshing state... (ID: vpc-0382578ed3cd51dcc)

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  - aws_vpc.main


Plan: 0 to add, 0 to change, 1 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value:
```

Then enter yes

```terraform
  Enter a value: yes

aws_vpc.main: Destroying... (ID: vpc-0382578ed3cd51dcc)
aws_vpc.main: Destruction complete after 0s

Destroy complete! Resources: 1 destroyed.
```

Now in AWS were back to as if we hadn't started.

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
<create a make file>
```

If you plan to turn this folder into a repo you need to install the config (at the root of the repo)
with:

```shell
$ pre-commit install
pre-commit installed at .\.git\hooks\pre-commit
```

Link:

Tf-scaffold <https://github.com/JamesWoolfenden/tf-scaffold>

Help documents for Terraform AWS Virtual Private Cloud (VPC) object are here <https://www.terraform.io/docs/providers/aws/r/vpc.html>

VPC designs <https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Scenarios.html>
