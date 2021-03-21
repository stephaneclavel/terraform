## Objective

Create AWS S3 buckets. 
Upload code to AWS S3 bucket. 
Create AWS Lambda function. 
Create API gateway as web front-end for Lambda function. 
Query API gateway to trigger Lambda function. 

Run script.xx and specify code version to run (1.0.0 or 1.0.1). 
Run destroy.xx to clean-up. 

Source: https://learn.hashicorp.com/tutorials/terraform/lambda-api-gateway?in=terraform/aws

## Test

Version 1.0.0 should return "Hello world!"
Version 1.0.1 should return "Bonjour au monde!"

## Note

This project leverages remote TF backend, see providers.tf file. 
