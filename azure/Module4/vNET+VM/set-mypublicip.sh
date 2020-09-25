#!/bin/bash
export TF_VAR_mypublicip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
echo "my public IP is $TF_VAR_mypublicip"
