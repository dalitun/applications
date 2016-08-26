
#!/bin/bash

if [[ $1 == dn ]];then
then

 curl -X POST -k $(openstack stack output show  -f json  autoscale scale_dn_url | jq '.output_value')

elif [[ $1 == up ]]; then

 curl -X POST -k $(openstack stack output show  -f json  autoscale scale_up_url | jq '.output_value')

else

	echo "no autoscale"

fi	