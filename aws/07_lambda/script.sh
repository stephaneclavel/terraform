#!/bin/bash

cd .\a_s3_code\
terraform apply -auto-approve
bucket=$(terraform output -json | jq -r .bucket_name.value)
aws s3 cp code.zip s3://$output/v1.0.0/code.zip