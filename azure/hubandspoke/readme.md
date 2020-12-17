This set-up creates:

on-prem vnet in Az region A, which includes 
  - a linux vm 
  - a VPN gateway, connected to cloud hub vnet VPN gateway. 

cloud hub vnet in Az region B, which includes
  - a VPN gateway, connected to on prem vnet VPN gateway
  - a linux VM acting as VNA in dmz subnet, with ip forwarding activated
  - a linux VM in mgmt subnet
  - vnet peerings to spoke1 and spoke2 vnets

cloud spoke1 vnet in Az region B, which includes
  - a linux vm
  - vnet peering to hub vnet

cloud spoke2 vnet in Az region B, which includes
  - a linux vm
  - vnet peering to hub vnet

Tests:
  - ssh to on prem vm
  - from on prem vm, ssh to hub, spoke1 and spoke2 vms

As usual set env vars to connect to Azure with set-azure-env-var.sh and set client IP address with set-mypublicip.sh
