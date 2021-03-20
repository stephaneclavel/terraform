Set-Location .\a_s3_code\
terraform.exe apply -auto-approve
$output = terraform output bucket_name
$key = "v1.0.0/code.zip"
aws s3 cp code100.zip s3://$output/$key

Set-Location ..\b_lambda_api\

Set-Location ..