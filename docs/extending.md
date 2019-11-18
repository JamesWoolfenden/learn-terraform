
# Custom  Terraform

## How to use an unapproved provider

Get binary from Github
Unzip the zip file
Then move exe binary to $HOME/.terraform.d/plugins directory
mkdir -p $HOME/.terraform.d/plugins

Unapproved providers
- auth0
https://github.com/alexkappa/terraform-provider-auth0

- akamai
https://developer.akamai.com/tools/integrations/terraform

- cloudflare
  
- signalfx

- signal form 
https://github.com/stripe/terraform-provider-signalform

- snowflake
https://github.com/chanzuckerberg/terraform-provider-snowflake

- spinnaker
https://github.com/armory-io/terraform-provider-spinnaker

## Extending Terraform

how to write a provider
https://www.terraform.io/docs/extend/writing-custom-providers.html
http://blog.jfabre.net/2017/01/22/writing-terraform-provider/
https://medium.com/spaceapetech/creating-a-terraform-provider-part-1-ed12884e06d7
https://medium.com/spaceapetech/creating-a-terraform-provider-part-2-1346f89f082c
https://petersouter.xyz/writing-and-playing-with-custom-terraform-providers/