# tf-lambda

tf-lambda provides a simple, easy-to-use starting point for creating and managing AWS Lambda resources using Terraform.

## Setup

1. Go to https://github.com/cfredmond/tf-lambda/generate
2. Add your repository name, a description (optional), set the branch visibility and click `Create repository from template`
3. Once your repository is created clone it to your system
4. From your terminal, cd into your repo and run
```
terraform init
terraform plan
```
5. Review the plan then run
```
terraform apply
```

This will package and deploy the lambda in the `example` folder.