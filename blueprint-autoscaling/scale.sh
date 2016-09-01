
#!/bin/bash



if [[ $2 == up || $2 == dn ]];then

 URL=$(openstack stack output show  -f json  $1 scale_$2_url | jq '.output_value' | sed -e 's/^"//'  -e 's/"$//')

 echo $URL

 curl -X POST -k "$URL"

else 


echo "nothing else matters"

fi
