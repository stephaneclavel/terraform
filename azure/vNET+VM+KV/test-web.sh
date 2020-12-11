#!/bin/bash

server=$(terraform output pip)      # server IP
port=80                 # port
connect_timeout=5       # Connection timeout

timeout $connect_timeout bash -c "</dev/tcp/$server/$port"
if [ $? == 0 ];then
   echo "Connection to $server over port $port is possible"
else
   echo "connection to $server over port $port is not possible"
fi
