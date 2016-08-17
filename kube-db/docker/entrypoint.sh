#!/bin/bash
mongod "$@" &
echo "$@" | grep "replSet"
if [ $? == 0 ]; then
/rs-config.sh
fi 
mongod "$@"