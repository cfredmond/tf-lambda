#!/bin/sh

# copy lib code
cp -R example/ example.copy/

# copy lib code
cp -R venv/lib/python3.10/site-packages/* example/

# terraform init
terraform init

# terraform apply
terraform apply

# delete lib code
rm -rf example
mv example.copy/ example/