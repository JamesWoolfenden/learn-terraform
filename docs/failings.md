# Failings

## When Terraform isn't great

- Objects that take a long time to create are suitable candidates.
  Active Directory integrations, Elastic search clusters, Kubernetes clusters can all take > 15 to 30 minutes to create.

- Objects that are fragile.
  Some AWS resources are built with Cloudformation behind the scenes, any changes, even minor can take forever.

- Objects with significant cascading effects.
  Creating and modifying Active Directory

- Naming [aws fault] or recreating objects that have just been destroyed

- API Gateway has its' own concept of environments/layers and can create a complex structure in Terraform that varies according to the code where no obvious model to make a module exists.
