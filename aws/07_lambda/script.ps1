Set-Location .\a_s3_code\
terraform.exe apply -auto-approve
$env:TF_VAR_bucket = terraform output bucket_name
$env:TF_VAR_bucket = $env:TF_VAR_bucket.Trim('"')
$env:TF_VAR_key = "v1.0.0/code.zip"
aws s3 cp code100.zip s3://$env:TF_VAR_bucket/$env:TF_VAR_key

Set-Location ..\b_lambda_api\

terraform.exe apply -auto-approve
$url = terraform output base_url
$url = $url.Trim('"')
Invoke-WebRequest $url

Set-Location ..