#!/bin/bash
input=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
hostnamectl set-hostname instance-$input
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
cd /var/www/html
echo "<html><h1>Hello from $(hostname)</h1></html>" > index.html
