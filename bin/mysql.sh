#!/usr/bin/env bash
set -e
source ./docker/magento2/env
docker-compose  exec deity_magento2_mysql mysql -hlocalhost -uroot -p${MYSQL_ROOT_PASSWORD} "${MYSQL_DATABASE}" $@