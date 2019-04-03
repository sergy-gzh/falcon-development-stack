#!/usr/bin/env bash

HOST_IP_ADDRESS=$(docker network inspect --format "{{range .IPAM.Config}}{{.Gateway}}{{end}}" fds_default | sed -E 's/\/[0-9]{1,2}$//')

sed -e "s/\${main_host_ip_address}/${HOST_IP_ADDRESS}/" docker/magento2/config/xdebug_template.ini > docker/magento2/config/xdebug_new.ini

MAGENTO_CONTAINER=$(docker container ls -q --filter name=deity_magento2_1)

docker cp docker/magento2/config/xdebug_new.ini ${MAGENTO_CONTAINER}:/usr/local/etc/php/conf.d/xdebug.ini

docker exec -i ${MAGENTO_CONTAINER} /bin/bash -c "service apache2 restart"

rm docker/magento2/config/xdebug_new.ini
