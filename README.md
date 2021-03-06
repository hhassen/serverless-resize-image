# Serverless Image Resizer

In this project, we deploy an API to resize and store images in a public s3 bucket.

With the following request to the application, the image is resized, stored and accessible from s3.

```
curl --location --request POST 'https://wt4wzbhls6.execute-api.us-east-1.amazonaws.com/master/image' \
--form 'file=@img.jpg' \
--form 's3Key=img.jpg'
``` 

The architecture of the project is the following :

![architecture](https://raw.githubusercontent.com/hhassen/serverless-resize-image/master/img/resize_image_architecture.png "Architecture")


## Infra as a Code
All the infrastructure is done using IaaC practice. I used both `serverless framework` and `terraform` to provision the infrastructure.

#### When to use Terraform and when to use Serverless Framework:
* Serverless for app-specific infrastructure : here I used it to provision :
	- API Gateway
	- Lambda
	- Cloudwatch Log Group
	- X-ray tracing

* Terraform for shared infrastructure : coupling shared infrastructure to a specific application isn’t a good practice. Shared infrastructure will usually get updated instead of re-created from scratch.
	- S3 Bucket

#### Sharing data between Terraform and Serverless with SSM parameters
First, we store the bucket name in SSM using terraform:
```
# Terraform Code
# Store S3 Bucket name in SSM
resource "aws_ssm_parameter" "endpoint" {
  name        = "/${var.project}/s3/name"
  description = "${var.bucket_name} BUCKET NAME"
  type        = "String"
  value       = module.s3_bucket.s3_bucket_id
}
```

Then, we import the parameter in our `Serverless Framework` from SSM parameter store:
```
# Serverless Framework code
# User get Bucket name from SSM
custom:
  bucket: ${ssm:/resize-image/s3/name~true}
...
  iam:
    role:
      statements:
        - Effect: Allow
          Action:
            - s3:PutObject
            - s3:PutObjectAcl
          Resource: "arn:aws:s3:::${self:custom.bucket}/*"
```


## CI/CD
All the steps, even the Terraform infrastructure, were automated using *Github Actions* to implement CI/CD best practices.
No action is needed from the developers apart from pushing their code to the Github repo.

We have 2 different jobs to deploy the infrastructure and the application : a **terraform job** and a **build and deploy job**.

I have put these jobs in different workflow files so that we can decouple our shared infrastructure and our app-specific infrastructure. We don't need to update our shared infrastructure every time we push some code to our branches. Updates are less frequent and we only trigger this job using pull requests and merges.


### Terraform job
This job provisions shared infrastructure.
Some of these steps only run from pull requests; others only run when you merge a commit to `master`.

![terraform workflow](https://raw.githubusercontent.com/hhassen/serverless-resize-image/master/img/workflow_github_actions_terraform.png "terraform workflow")

![terraform PR](https://raw.githubusercontent.com/hhassen/serverless-resize-image/master/img/pull_request.png "terraform PR")

### Serverless CI/CD
This job provisions app-specific infrastructure.
This job is triggered every time we push changes to `dev` or `master` branches.
This job builds and deploys the lambda package using a Github-hosted runner (Ubuntu).

## Logs and tracing
Logs are sent to Cloudwatch Logs.
Tracing is done using X-ray service.


![x-ray tracing](https://raw.githubusercontent.com/hhassen/serverless-resize-image/master/img/x-ray_tracing.png "x-ray tracing")


## Next steps
#### 1. Add authentication using API Gateway
Different mechanisms can be used for authentication and authorization in API Gateway:
* **Resource policies** let you create resource-based policies to allow or deny access to your APIs and methods from specified source IP addresses or VPC endpoints.
* **Standard AWS IAM roles and policies** offer flexible and robust access controls that can be applied to an entire API or individual methods.
* **Amazon Cognito user pools** let you create customizable authentication and authorization solutions for your REST APIs. 

#### 2. Move shared infrastructure in a separate repo