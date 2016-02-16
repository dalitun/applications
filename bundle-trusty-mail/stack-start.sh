#!/bin/bash

heat stack-create $1 -f bundle-trusty-mail.heat.yml -Pkeypair_name=$2
