#!/bin/bash

heat stack-create $1 -f bundle-trusty-webmail.heat.yml -Pkeypair_name=$2 -Pmysql_password=$3 -Ppostfix_admin=$4
