#!/bin/bash
export TF_VAR_mypublicip="$(dig +short myip.opendns.com @resolver1.opendns.com)"

