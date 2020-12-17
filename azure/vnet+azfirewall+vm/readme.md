1/ set necessary env var to connect to Azure . ./set-azure-env-var.sh and client public ip address with set-mypublicip.sh

2/ This creates a Vnet, an Az Firewall with outbound DNS, inbound ssh and web allowed, and a VM running web server. 

Connectivity to web server can be tested with test-web.sh shell script and ssh with test-ssh.sh. 
