#/bin/bash
if [ $# -eq 1 ]

then

LIST=$(nova list | awk '{ print $4 }' | grep -v "Name" | tr "\n" " ")

for instance in $LIST
do 
STATUS=$(nova show $instance | grep status | awk '{ print $4 }')
if [ "$1" == "shelve" ] && [ "$STATUS" == "ACTIVE" ]
  then
      echo "$instance is shelved at $(date +%Y-%m-%d-%H.%M.%S)" >> shelving.log
      nova shelve $instance
elif [ "$1" == "unshelve" ] && [ "$STATUS" == "SHELVED_OFFLOADED" ]
  then
      echo "$instance is unshelved at $(date +%Y-%m-%d-%H.%M.%S)" >> shelving.log
      nova unshelve $instance
else 

 echo "you must to use shelve if instance status is ACTIVE or unshelve if instance status is SHELVED_OFFLOADED"

fi 

done

else 

echo "Usage $0 shelve or unshelve  "

fi

