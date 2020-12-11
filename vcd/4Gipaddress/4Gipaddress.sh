#!/bin/bash
export TF_VAR_myip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
terraform apply -var-file="/home/steph/.secrets.tfvars"
