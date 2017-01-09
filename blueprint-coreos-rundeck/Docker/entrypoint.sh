#!/bin/bash
ls -l /etc/rundeck
source /etc/rundeck/profile

$rundeckd &

while true
do
  </dev/tcp/localhost/22 2>/dev/null

   if [ "$?" -ne 0 ]
   then
   echo "wait rundeck will be up"
   else
   echo "rundeck is up"
   break
fi
done

export RD_URL=$(awk -F= "/grails.serverURL/ {print \$2}" /etc/rundeck/rundeck-config.properties)
export RD_USER=admin RD_PASSWORD=admin
rd projects create -p InstancesSnapshot
rd jobs load --file snapshot.xml --project InstancesSnapshot
