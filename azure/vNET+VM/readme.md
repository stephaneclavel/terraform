1/ set necessary env var to connect to Azure . ./set-azure-env-var.sh 

2/ deploys RG, vnet, subnet, rules, NSG, pip, nic, storage account (for boot diag), linux vm and web server. 

Connectivity to web server can be tested with test-web.sh shell script, ssh connectivity with test-ssh.sh. 
