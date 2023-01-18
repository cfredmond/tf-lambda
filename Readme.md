# tf-lambda

tf-lambda provides a simple, easy-to-use starting point for creating and managing AWS Lambda resources using Terraform.

## Setup

1. Go to https://github.com/cfredmond/tf-lambda/generate to access the tf-lambda tool and generate your template.
2. Enter your desired repository name, add a brief and informative description (if desired), select the appropriate branch visibility setting, and click the `Create repository from template` button to create a new repository using the selected template.
3. Clone the repository to your local system for editing.
4. Navigate to the cloned repository and set up a virtual environment by running the following commands:
```
python -m venv venv
source venv/venv/bin/activate
```
5. Install any required packages and add your lambda code to the example.py file in the example folder.
6. Package your lambda and its dependencies by running:
```
./package.sh
```
7. Initialize terraform and run the plan command:
```
terraform init
terraform plan
```
8. Review the plan and make any necessary adjustments, then run:
```
terraform apply
```

This command will package and deploy the contents of the example folder as a Lambda function on AWS, making it ready for use.