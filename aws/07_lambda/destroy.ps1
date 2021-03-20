Set-Location .\a_s3_code\
terraform.exe destroy

Set-Location ..\b_lambda_api\
terraform.exe destroy

Set-Location ..