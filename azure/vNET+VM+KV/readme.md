1/ set necessary env var to connect to Azure . ./set-azure-env-var.sh 

2/ deploys RG, vnet, subnet, rules(no rdp rule, need JIT), NSG, pip, nic, storage account (for boot diag), windows vm with admin password stored in an existing KV, custom script extension (requires vm agent) and enables web server. 

Connectivity to web server can be tested with test-web.sh shell script
