#!/bin/bash

heat stack-create $1 -f bundle-freebsd-pfsense.heat.yml -Pkeypair_name="$2" -Pprivate_net_cidr="$3" -Ppublic_net_cidr="$4"
