1/ set necessary env var to connect to Azure . ./set-azure-env-var.sh 

2/ deploys RG, vnet, subnet, rules, NSG, pip, nic, storage account (for boot diag), spot linux vm and web server. Tests connectivity to VM via web and http. 

Note: if spot VMs are not available at the moment you deploy in the selected region, deployment will fail: 

Error: creating Linux Virtual Machine "vm-demo-test-westeurope-001" (Resource Group "rg-demo-test-westeurope-001"): compute.VirtualMachinesClient#CreateOrUpdate: Failure sending request: StatusCode=0 -- Original Error: autorest/azure: Service returned an error. Status=<nil> Code="SkuNotAvailable" Message="The requested size for resource '/subscriptions/88e98c7d-911a-45db-87e2-c788bd626c53/resourceGroups/rg-demo-test-westeurope-001/providers/Microsoft.Compute/virtualMachines/vm-demo-test-westeurope-001' is currently not available in location 'westeurope' zones '' for subscription '88e98c7d-911a-45db-87e2-c788bd626c53'. Please try another size or deploy to a different location or zones. See https://aka.ms/azureskunotavailable for details."

In this case one can comment the 2 below lines:
priority              = "Spot"
eviction_policy       = "Deallocate"

Connectivity to web server can be tested with test-web.sh shell script, ssh connectivity with test-ssh.sh. 
