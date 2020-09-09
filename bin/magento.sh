#!/usr/bin/env bash
set -a
docker-compose  exec -u www-data magento2_phpfpm /var/www/html/bin/magento $@
