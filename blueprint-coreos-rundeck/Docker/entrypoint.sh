#!/bin/bash
ls -l /etc/rundeck
source /etc/rundeck/profile
/bin/bash -c "$rundeckd"

export RD_URL=$(awk -F= "/grails.serverURL/ {print \$2}" /etc/rundeck/rundeck-config.properties)
export RD_USER=admin RD_PASSWORD=admin

rd projects create -p test
