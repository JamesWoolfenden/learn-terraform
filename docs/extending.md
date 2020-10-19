
# Custom Terraform

## How to use an unapproved provider

Get the binary (i.e. from Github).
Unzip the zip file.
Then move exe binary to **$HOME/.terraform.d/plugins** directory.
Ensure that you have the cache folder.

```cli
mkdir -p $HOME/.terraform.d/plugins
```

## Unapproved providers

- snowflake
<https://github.com/chanzuckerberg/terraform-provider-snowflake>

## Extending Terraform

How to write a provider

<https://www.terraform.io/docs/extend/writing-custom-providers.html>
<http://blog.jfabre.net/2017/01/22/writing-terraform-provider/>
<https://medium.com/spaceapetech/creating-a-terraform-provider-part-1-ed12884e06d7>
<https://medium.com/spaceapetech/creating-a-terraform-provider-part-2-1346f89f082c>
<https://petersouter.xyz/writing-and-playing-with-custom-terraform-providers/>
