#!/bin/bash

server=$(terraform output azfw-pip)      # server IP
port=22                 # port
connect_timeout=5       # Connection timeout

ssh -q -o BatchMode=yes  -o StrictHostKeyChecking=no -o ConnectTimeout=$connect_timeout $server 'exit 0'
if [ $? == 0 ];then
   echo "SSH Connection to $server over port $port is possible"
else
   echo "SSH connection to $server over port $port is not possible"
fi
