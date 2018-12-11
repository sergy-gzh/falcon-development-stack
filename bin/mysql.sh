#!/usr/bin/env bash
set -e
source ./docker/magento2/env

if [ -t 0 ] ; then
    tty="-it"
else
    tty="-i"
fi
docker exec $tty $(docker container ls -q --filter name=deity_magento2_mysql) mysql -hlocalhost -uroot -p${MYSQL_ROOT_PASSWORD} "${MYSQL_DATABASE}" $@
