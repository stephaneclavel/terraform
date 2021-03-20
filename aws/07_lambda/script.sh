#!/bin/bash

cd ./a_s3_code/
terraform apply -auto-approve
bucket=$(terraform output -json | jq -r .bucket_name.value)
aws s3 cp code100.zip s3://$output/v1.0.0/code.zip

cd ../b_lambda_api/

cd ..