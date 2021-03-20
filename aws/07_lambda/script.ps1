Set-Location .\a_s3_code\
terraform.exe apply -auto-approve
$output = terraform output bucket_name
aws s3 cp code.zip s3://$output/v1.0.0/code.zip

