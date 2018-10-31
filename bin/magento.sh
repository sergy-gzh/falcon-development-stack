#!/usr/bin/env bash
set -a
docker-compose  exec -u www-data deity_magento2 /var/www/html/bin/magento $@
