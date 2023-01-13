# tf-lambda

Terraform lambda starter project

## Setup and development

1. Go to https://github.com/cfredmond/tf-lambda/generate
2. Add your repository name, a description (optional), set the branch visibility and click `Create repository from template`
3. Once your repository is created clone it to your system
4. From your terminal, cd into your repo and run
```
python -m venv venv
source venv/bin/activate
```
5. Install your dependencies and add your lambda logic to the `example/example.py` script
6. To deploy your lamnda run the build script in the root directory
```
./build.sh
```

This will package and deploy the lambda in the `example` folder.