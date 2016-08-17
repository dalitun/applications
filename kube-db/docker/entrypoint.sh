#!/bin/bash
mongod "$@" &
echo "$@" | grep "repSet"
if [ $? == 0]; then
/rs-config
fi 
mongo