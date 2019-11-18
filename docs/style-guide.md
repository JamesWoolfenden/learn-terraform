# Style Guide

1. Fixed versions for Terraform.
2. One file resource per resource, except when resources are tightly coupled - e.g. policies & roles, security group and rules.
3. File names reflect resource name.
4. Install and use pre-commit hooks.
5. Use terraform-docs and maintain a readme in each module.
6. Each module should have a test module in this repo.
7. Ensure that you tag of know good versions.
8. PRs to use names like feature-_and fix-_.
9. Each test project should have a jenkinsfile and make file.
10. Ensure that all variables and objects are used (VScode can tell you if variables are actually used).
11. Use data resources over hard-coding.
12. Use common_tags to help you follow a tagging strategy.
13. Set Versions for providers if possible.
14. Automate build process for modules.

## Modules

1. Passing data versus data sources.