1/ set necessary env var to connect to Azure . ./set-azure-env-var.sh 

2/ admin_password variable has a default value, should be overiden by terraform applay -var admin_password="" or set env var echo TF_VAR_admin_password=value
