1/ set necessary env var to connect to Azure . ./set-azure-env-var.sh 

2/ deploys RG, vnet, subnet, NSG and rules(no rdp rule, need JIT (Just In Time) access), PIP (Public IP), nic, storage account (for boot diagnostics), windows vm with admin password stored in an existing KV (Key Vault), custom script extension (requires vm agent) and enables web server. 

Connectivity to web server can be tested with test-web.sh shell script
