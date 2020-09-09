#!/usr/bin/env bash
set -e
source ./docker/magento2/env

if [ -t 0 ] ; then
    TTY="-it"
else
    TTY="-i"
fi
docker exec $TTY $(docker container ls -q --filter name=magento2_db) mysql -hlocalhost -uroot -p${MYSQL_ROOT_PASSWORD} "${MYSQL_DATABASE}" $@
