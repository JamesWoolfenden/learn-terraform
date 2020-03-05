# Failing

## When Terraform isn't great

- objects that take a long time to create
  Active Directory integrations, Elastic search clusters, Kubernetes clusters

- objects that are fragile
  Some AWS resources are built with Cloudformation behind the scenes, any changes even minor take forever.

- objects with significant cascading effects
  Creating and modifying Active Directory

- naming [aws fault] or recreating objects that have just been destroyed

- API gateway has its own concept of environments/layers and it's structure varies according to the code.
