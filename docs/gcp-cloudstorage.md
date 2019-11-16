# Cloud Storage

## Using Cloud storage for a Helm repository

The first to create a test repo from the charts folder

```cli
helm serve --repo-path ./charts
```

This supplies a sample **index.yaml**, which is added as part of the repo creation process [it's in the template folder for the example].

When you provision the example it will create a public helm repo. You will have to change the name as they are required to be globally unique.

<https://helm-repo-examplea.storage.googleapis.com/>

This example has a mininal **index.yaml**

## Adding the repo to your Helm

```helm
helm repo add baby-steps https://helm-repo-examplea.storage.googleapis.com/
"baby-steps" has been added to your repositories
```

Verify:

```helm
$helm repo list
NAME            URL
stable          https://kubernetes-charts.storage.googleapis.com
baby-steps      https://helm-repo-examplea.storage.googleapis.com/
```

## Usage

Add **module.storage.tf** to your code:-

```terraform
module "storage" {
  source      = "JamesWoolfenden/storage/gcp"
  version     = "0.2.3"
  binding     = var.binding
  bucket_name = var.bucket_name
  project     = var.project
  location    = var.location
}
```

## Permissions

This being GCP you'll get this error when was making this project, your service acccount will need these permissions, Included in the "Cloud Storage Admin" role.

```error
 examplea@examplea.iam.gserviceaccount.com does not have storage.buckets.create access to project XXXXXX, forbidden
```

!!!Note Links
<https://github.com/JamesWoolfenden/terraform-gcp-storage>
