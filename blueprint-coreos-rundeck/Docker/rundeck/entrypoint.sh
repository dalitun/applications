#!/bin/sh

set -e



  RD_DB_URL="jdbc:mysql://$MYSQL_HOST:$MYSQL_PORT/$MYSQL_DATABASE?autoReconnect=true"

  
  sed -i 's,grails.serverURL\=.*,grails.serverURL\='${RD_URL}',g' /rundeck/server/config/rundeck-custom.properties
  sed -i 's,dataSource.dbCreate.*,,g' /rundeck/server/config/rundeck-custom.properties
  sed -i 's,dataSource.url = .*,dataSource.url = '${RD_DB_URL}',g' /rundeck/server/config/rundeck-custom.properties
  


  echo "dataSource.username = ${MYSQL_USER}" >> /rundeck/server/config/rundeck-custom.properties
  echo "dataSource.password = ${MYSQL_PASSWORD}" >> /rundeck/server/config/rundeck-custom.properties


  

/usr/bin/java -XX:MaxPermSize=256m -Xmx1024m \
  -Dserver.http.port=4440 \
  -Dserver.http.host=0.0.0.0 \
  -Dserver.web.context=$RD_WEB_CONTEXT \
  -Drdeck.base=$RD_BASE \
  -Ddefault.user.name=$RD_USER \
  -Ddefault.user.password=$RD_PASSWORD \
  -Drundeck.config.name=rundeck-custom.properties \
  -jar /rundeck/rundeck-launcher.jar 



