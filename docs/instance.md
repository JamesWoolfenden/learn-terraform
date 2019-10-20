# Creating an EC2 INstance

## Make an instance in a public sub-net

Open your shell again and get a new scaffold:

```cli
scaffold aws_instance
```

add **aws_instance.web.tf** to the new scaffold.

```terraform
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  tags = "${var.common_tags}"
}
```

Rather than hardcoding the AMI like above, a better and more maintainable way it to get the latest AMI made of that type:
Adding an ami data source is a better way, like this one for ubuntu xenial **data.aws_ami.xenial.tf**:

```terraform
data "aws_ami" "xenial" {
  most_recent      = true
  owners           = ["099720109477"]

  filter {
    name = "name"
    values = ["ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}
```

Then update the AMI reference in aws_instance to:

```terraform
ami           = data.aws_ami.xenial.id
```

If you apply now the latest xenial AMI will start, and as just about every other property isn't specified it will use the defaults for VPC, Subnet and Security Group.

```terraform
 + aws_instance.web
      id:                           <computed>
      ami:                          "ami-01bc69b830b49f729"
      arn:                          <computed>
      associate_public_ip_address:  <computed>
      availability_zone:            <computed>
      cpu_core_count:               <computed>
      cpu_threads_per_core:         <computed>
      ebs_block_device.#:           <computed>
      ephemeral_block_device.#:     <computed>
      get_password_data:            "false"
      host_id:                      <computed>
      instance_state:               <computed>
      instance_type:                "t2.micro"
      ipv6_address_count:           <computed>
      ipv6_addresses.#:             <computed>
      key_name:                     <computed>
      network_interface.#:          <computed>
      network_interface_id:         <computed>
      password_data:                <computed>
      placement_group:              <computed>
      primary_network_interface_id: <computed>
      private_dns:                  <computed>
      private_ip:                   <computed>
      public_dns:                   <computed>
      public_ip:                    <computed>
      root_block_device.#:          <computed>
      security_groups.#:            <computed>
      source_dest_check:            "true"
      subnet_id:                    <computed>
      tags.%:                       "1"
      tags.createdby:               "Terraform"
      tenancy:                      <computed>
      volume_tags.%:                <computed>
      vpc_security_group_ids.#:     <computed>
```
