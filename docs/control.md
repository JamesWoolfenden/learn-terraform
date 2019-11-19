# Structuring your code

todo

- terraform with app code

- infrastructure only
  Making account structure, networks and subs users and auth

## level of control

todo

## infrastructure projects verses application development

todo

from base AWS account to application level

## multi account development issues

todo

## cross account

cross account roles
cassandra cluster

## When Terraform isn't great

- objects that take a long time to create
  Active Directory integrations, Elastic search clusters, Kubernetes clusters

- objects that are fragile
  Some AWS resources are built with Cloudformation behind the scenes, any changes even minor take forever.

- objects with significant cascading effects
  Creating and modifying Active Directory

- naming [aws fault] or recreating objects that have just been destroyed
