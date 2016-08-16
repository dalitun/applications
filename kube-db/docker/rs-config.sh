#!/bin/bash


set -x

MYHOST=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
POD_NAMESPACE=${POD_NAMESPACE:-default}
POD_NAME=${POD_NAME:-"mongo"}
token=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
URL="https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT}/api/v1/namespaces/${POD_NAMESPACE}/endpoints/${POD_NAME}"
IP=$(curl -s $URL --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt --header "Authorization: Bearer ${token}" | jq '.subsets[] .addresses[].ip')
MEM=($(echo $IP))
SIZE=${#MEM[@]}

if [ $SIZE == $NODE_COUNT ]
then
   mongo --host $MYHOST --port 27017 --eval "printjson( rs.initiate())"

   F=$(echo ${MEM[0]} | sed -e 's/^"//'  -e 's/"$//')


 if [ $F == $MYHOST ]
 then
  for (( i=1; i<$SIZE; i++ ));
     do
      #config for primary
      member=$(echo ${MEM[$i]} | sed -e 's/^"//'  -e 's/"$//')
      mongo --host $MYHOST --port 27017 --eval "printjson(rs.add('$member:27017'))"
   done

 else
     #config for primary
     mongo --host $MYHOST --port 27017 --eval "printjson(rs.slaveOk())"

 fi

else
 echo "you have to wait when pods will be created"

fi
