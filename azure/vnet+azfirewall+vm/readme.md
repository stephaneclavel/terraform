1/ set necessary env var to connect to Azure . ./set-azure-env-var.sh 

2/ admin_password variable has a default value, should be overiden by terraform apply -var admin_password="" or set env var TF_VAR_admin_password=value

3/ This creates a Vnet, an Az Firewall with only outbound DNS allowed, and a VM. Connect to VM for test via console or Bastion
