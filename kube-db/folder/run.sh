#!/bin/bash
MYHOST=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
POD_NAMESPACE=${POD_NAMESPACE:-default}
POD_NAME=${POD_NAME:-"mongo-cluster"}
token=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
URL="https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT}/api/v1/namespaces/${POD_NAMESPACE}/endpoints/${POD_NAME}"
IP=$(curl -s $URL --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt --header "Authorization: Bearer ${token}" | jq '.subsets[] .addresses[].ip')
    






