#!/bin/bash

if [ $# -eq 4 ]

then

heat stack-create $1 -f bundle-trusty-webmail.heat.yml -Pkeypair_name=$2 -Pmysql_password=$3 -Ppostfix_admin_pass=$4

else

echo "usage $0 stack_name keypair_name mysql_password postfix_admin_pass"

fi
