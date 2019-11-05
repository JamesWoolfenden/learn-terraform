# Creating an Relation Database Service (RDS) instance with Terraform

RDS is one of the managed database services on AWS, many of the most common relational databases can be easily provisioned via RDS, including MySQL, Oracle and SQL Server.

## Getting Started

Again we start with a new Scaffold.

```cli
$ scaffold RDS-starter
git clone --depth=1 git@github.com:JamesWoolfenden/tf-scaffold.git RDS-starter
Cloning into 'RDS-starter'...
remote: Enumerating objects: 11, done.
remote: Counting objects: 100% (11/11), done.
remote: Compressing objects: 100% (8/8), done.
remote: Total 11 (delta 0), reused 6 (delta 0), pack-reused 0
Receiving objects: 100% (11/11), done.
```

Now that you have the scaffold you can add your components.

## Provision a basic RDS instance

Add this RDS resource to RDS-starter as **aws_db_instance.employee.tf**

```terraform
resource "aws_db_instance" "employee" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  skip_final_snapshot  = true
  publicly_accessible  = true
  username             = "Sleepycat"
  password             = "thr33littlew0rds"
  parameter_group_name = "default.mysql5.7"
}
```

And try out the template:

```cli
$ terraform plan
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  + aws_db_instance.employee
      id:                         <computed>
      address:                    <computed>
      allocated_storage:          "20"
      apply_immediately:          <computed>
      arn:                        <computed>
      auto_minor_version_upgrade: "true"
      availability_zone:          <computed>
      backup_retention_period:    <computed>
      backup_window:              <computed>
      ca_cert_identifier:         <computed>
      character_set_name:         <computed>
      copy_tags_to_snapshot:      "false"
      db_subnet_group_name:       <computed>
      endpoint:                   <computed>
      engine:                     "mysql"
      engine_version:             "5.7"
      hosted_zone_id:             <computed>
      identifier:                 <computed>
      identifier_prefix:          <computed>
      instance_class:             "db.t2.micro"
      kms_key_id:                 <computed>
      license_model:              <computed>
      maintenance_window:         <computed>
      monitoring_interval:        "0"
      monitoring_role_arn:        <computed>
      multi_az:                   <computed>
      name:                       "employee"
      option_group_name:          <computed>
      parameter_group_name:       "default.mysql5.7"
      password:                   <sensitive>
      port:                       <computed>
      publicly_accessible:        "true"
      replicas.#:                 <computed>
      resource_id:                <computed>
      skip_final_snapshot:        "false"
      status:                     <computed>
      storage_type:               "gp2"
      timezone:                   <computed>
      username:                   "Sleepycat"
      vpc_security_group_ids.#:   <computed>


Plan: 1 to add, 0 to change, 0 to destroy.
```

Before you apply add an output to **outputs.tf**

```terraform
output "endpoint" {
    value=aws_db_instance.employee.endpoint
}
```

Applying that should succeed, mine took around 4mins in my testing, and finally the output of the DBs endpoint:

```terraform
endpoint = employee.ch6wpf7x4jbf.eu-west-1.rds.amazonaws.com:3306
```

There are a large number of properties other than the ones we have supplied, so many defaults are being assumed. So far we haven't specified the VPC or even a Sub-net. Provisioning will add your DB instance in with many of the defaults.

Terraform displays that the instance has been provisoned, but we do need to verify.

## Testing DB Instance

Get will need to get the client MySQL tools installed:

```powershell
choco install mysql-cli
```

or

```Bash
brew install mysql
```

Now connecting to the instance is the proof:

```cli
$ mysql -h employee.ch6wpf7x4jbf.eu-west-1.rds.amazonaws.com -P 3306 -u Sleepycat -p
Enter password: ****************
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 6
Server version: 5.7.23 Source distribution

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

Now you have a connected SQL prompt so you can run your now SQL against the db.

### Warning

Earlier I set a property -  publicly_accessible="true" that made your db public, we wouldn't normally allow a db to be public.

## Multiple DBs

How can I provision 2 databases of the same type?
This is done by using the count variable and adding it to your resource:

```terraform
  count="2"
```

Additionally you will need to change the name so that it can be unique.

```terraform
name                   = "employee${count.index}"
```

When you plan again, it now raises this issue:

```terraform
* output.endpoint: Resource 'aws_db_instance.employee' not found for variable 'aws_db_instance.employee.endpoint'
```

This is because aws_db_instance.employee is now a list, the output reference now needs to support the blat array reference like this:

aws_db_instance.employee.*.endpoint

Now try plan angain and you'll find this plans just fine but it but you'll see that it will make 2 databases instances.

### Links

Sample data from <https://dev.mysql.com/doc/employee/en/employees-installation.html>

Terraform RDS <https://www.terraform.io/docs/providers/aws/r/db_instance.html>

AWS RDS terraform modul example <https://github.com/terraform-aws-modules/terraform-aws-rds/tree/master/examples/complete-mysql>

!!! Warning
    Delete you DB's and Clusters after you've finsihed as they cost ££££
 