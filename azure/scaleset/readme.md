creates a VMSS (VM Scale Set) with 2 instances in different AZ (Availability zones), vnet, nsg, lb with public ip address

instances run a web server, LB public ip fqdn is returned as an output

instance hostname is displayed on default web page to illustrate LB capability

--

Apply complete! Resources: 15 added, 0 changed, 0 destroyed.

Outputs:

vmss_public_fqdn = hztehb.westeurope.cloudapp.azure.com

[steph@centos7-2 scaleset]$ curl hztehb.westeurope.cloudapp.azure.com
<h1>Demo Bootstrapping Azure Virtual Machine vmss-demo-test-westeurope-001000003</h1>
[steph@centos7-2 scaleset]$ curl hztehb.westeurope.cloudapp.azure.com
<h1>Demo Bootstrapping Azure Virtual Machine vmss-demo-test-westeurope-001000002</h1>
[steph@centos7-2 scaleset]$ curl hztehb.westeurope.cloudapp.azure.com
<h1>Demo Bootstrapping Azure Virtual Machine vmss-demo-test-westeurope-001000003</h1>
[steph@centos7-2 scaleset]$ curl hztehb.westeurope.cloudapp.azure.com
<h1>Demo Bootstrapping Azure Virtual Machine vmss-demo-test-westeurope-001000002</h1>

