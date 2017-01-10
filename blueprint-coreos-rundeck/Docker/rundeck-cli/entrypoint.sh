#!/bin/sh

set -e


while ! nc -z $RD_HOST 4440; do
  sleep 0.1 
  echo "Wait for Rundeck will be UP"
done


/rd/bin/rd projects create -p InstancesSnapshot
/rd/bin/rd jobs load --file /snapshot.xml --project InstancesSnapshot


