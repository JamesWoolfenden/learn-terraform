# Creating a Subnet in AWS

The Terraform below is almost the most minimal Terraform configuration to create one subnet.
A subnet is a division of a VPC in one Availability Zone.

There is therefore a dependency to a VPC & its vpc_id and it has a smaller CIDR block, here, of 256 IPs.

Add this file **aws_subnet.main.tf** to your existing terraform in **aws_vpc**.

```terraform
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  tags       = var.common_tags
}
```

```terraform
$ terraform apply
...
```

Making one just one subnet is an unusual activity, as is not specifying the AvailabilityZone it is in or the Routes.
It is more common to see (if your in a 3 zone region) a Private and Public Subnet for each availability zone in a Region.

How many Availability Zones are there in this region?
You could hard-code this a variable and put the strings in your Terraform.tfvars, fortunately there's a better dynamic way.

Add **data.tf** to aws_vpc template.

```terraform
data "aws_availability_zones" "available" {}
```

This data object captures a list of the availability zones in your current region.
This can be used in other templates:

```terraform
data.aws_availability_zones.available.names
```

Now lets replace the previous subnet file with:
**aws_subnets.public.tf**

```terraform
resource "aws_subnet" "public" {
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.public_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags              = merge(var.common_tags, map("Type", "Public")
}
```

and add:
**locals.tf**

```terraform
locals{
 public_cidrs  = ["${cidrsubnet("${var.cidr}", 3, 0)}", "${cidrsubnet("${var.cidr}", 3, 1)}", "${cidrsubnet("${var.cidr}", 3, 2)}"]
}
```

And Append variables.tf with:

```terraform
variable "cidr" {
  default="10.0.0.0/16"
}
```

And update the vpc object to use the cidr variable

```terraform
cidr_block = var.cidr
```

That's quite and lot different and dropped a whole heap of new stuff, so time for a review:

## Count

```terraform
count             = length(data.aws_availability_zones.available.names)
```

This makes as many of the object aws_subnet.public as length(data.aws_availability_zones.available.names) evaluates to. That'll depends on how many Availability Zones are in your region, but it'll probably be 3.

## Locals

What is a local? You can't currently set the value of a variable as something dynamic or for that matter one that's calculated, but you can achieve the same thing with a local, as you can see above in **locals.tf**.

This makes an array of cidrblocks based on var.cidr using a built in function cidrsubnet.
This array then gets used with the indexer to give the CIDR ranges for each subnet.

```terraform
  cidr_block        = local.public_cidrs[count.index]
```

## Merging tags

```terraform
 tags = merge(var.common_tags, map("Type", "Public")
```

This is just the syntax to a a new variable to a map, so this map now has an extra key/value pair Type=Public.

So its time to test that syntax, with terraform init and plan

So thats a VPC and and 3 "Public" subnets with 8192 IPS in each.

## There's a bit more to being Public Subnet

So the Subnets may be called Public, but they still aren't.

## Routing

So what make a subnet public? The subnet need to be connected to the Internet. A common way is to connect and route an Internet Gateway.
Add in **aws_internet_gateway.gw.tf**

```terraform
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}
```

and then create a route and a route table with
**aws_route_table.public.tf**

```terraform
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = var.common_tags
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}
```

That's a complete set of public subnets. The next step would be to make a set of private subnets. But...

Not only can you get Design patterns to create your base networking, but you can get the Terraform as well, written by the Platform itself, so as setting up the basic VPC structure in AWS is a solved problem, you can use one of a number of tried and tested designs from the registry:

!!!Note
    <https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/1.60.0> has nearly 900k uses and rising, thats a lots of field testing and it saves a tonne of typing.
    
    <https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Scenario2.html>
