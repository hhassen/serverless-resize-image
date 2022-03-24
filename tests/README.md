## How to test the API
Use the shell scripts to test the API method.

Using a local `img.jpg` file, the lambda function shoud create the following files in the S3 bucket :
- img.jpg : https://aws-bucket-hhassen-2022mars.s3.us-east-1.amazonaws.com/img.jpg
- img.jpg_200 : https://aws-bucket-hhassen-2022mars.s3.us-east-1.amazonaws.com/img.jpg_200
- img.jpg_75 : https://aws-bucket-hhassen-2022mars.s3.us-east-1.amazonaws.com/img.jpg_75

![image](https://raw.githubusercontent.com/hhassen/serverless-resize-image/master/img/tests/img.jpg "image")