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

Write-Host "Creating Lambda function, custom domain name and API gateway" -ForegroundColor red
terraform.exe apply -auto-approve
#$url = terraform output base_url
#$url = $url.Trim('"')
$domain_name = terraform.exe output url
$domain_name = $domain_name.Trim('"')
$stage_name = terraform.exe output stage_name
$stage_name = $stage_name.Trim('"') 
$url = "https://"+$domain_name+"/"+$stage_name
$content = Invoke-WebRequest $url
Write-Host "Url" $url "triggered lambda function and returned:" -ForegroundColor red
$content.content

Set-Location ..