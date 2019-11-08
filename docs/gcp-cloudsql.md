# CloudSQL

You need to have enabled the API's for this to work if you haven't used this part of GCP before:

[servicenetworking.googleapis.com](https://console.developers.google.com/apis/api/servicenetworking.googleapis.com/overview)

[sqladmin.googleapis.com](https://console.developers.google.com/apis/api/sqladmin.googleapis.com/overview)

Once the API's are enabled you have grant these roles:

```text
Storage Admin
Cloud SQL Admin
```

To your Terraform user. 

## Private Instance

Create a database instance, x databases with x number of users. This instance is created privately within your selected VPC.

Add **module.cloudsql.tf** to your code [see other objects](https://github.com/JamesWoolfenden/terraform-gcp-cloudsql/tree/master/example/examplea):-

module cloudsql {
  source       = "JamesWoolfenden/cloudsql/gcp"
  version      = "0.1.13"
  name         = var.name
  project      = var.project
  network_name = var.network_name
  database     = var.database
  users        = var.users
}

This creates any number of databases through the the variable "database":

```HCL
variable "database" {
    type=list(object({
        name = string
    }))
    default=[]
}
```

Setting database to
```HCL
    database=[{
        name= "my-database"
    },
    {
        name= "your-database"
    }]
```

Will create 2 databases.
The "Users" variable and resource follows the same pattern.

