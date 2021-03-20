$version = Read-Host -Prompt 'Input code version (1.0.0 or 1.0.1)'
Set-Location .\a_s3_code\
Write-Host "Creating S3 buckets" -ForegroundColor red
terraform.exe apply -auto-approve
$env:TF_VAR_bucket = terraform output bucket_name
$env:TF_VAR_bucket = $env:TF_VAR_bucket.Trim('"')
$env:TF_VAR_key = "v$version/code.zip"
Write-Host "Uploading code to bucket" -ForegroundColor red
aws s3 cp code$version.zip s3://$env:TF_VAR_bucket/$env:TF_VAR_key

Set-Location ..\b_lambda_api\

Write-Host "Creating Lambda function and API gateway" -ForegroundColor red
terraform.exe apply -auto-approve
$url = terraform output base_url
$url = $url.Trim('"')
$content = Invoke-WebRequest $url
Write-Host "Lambda function returned:" -ForegroundColor red
$content.content

Set-Location ..