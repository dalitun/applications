#!/bin/bash

if [ ! -z $1 ]; then
    exec "$@">/dev/null 2>&1&
    sleep 10
    /rs-config.sh
else

echo "you don't wanna exec mongodb"

fi