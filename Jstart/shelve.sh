#/bin/bash
#TYPE=shelve ou unshelve
TYPE=$1

if [ $# -eq 1 ]
 
then

LIST=$(nova list | awk '{ print $4 }' | grep -v "Name" | tr "\n" " ") 
for instance in $LIST
  do
if [ "$TYPE" -eq "shelve"] || [ "$TYPE -eq "unshelve" ]
  then
     nova $TYPE $instance
     echo "$instance $TYPEd at $(date +%Y-%m-%d-%H.%M.%S)" >> shelving.log

  else 

 echo "you must to use shelve or unshelve"

fi 

done

else 

echo "Usage $0 shelve or unshelve  "

fi
