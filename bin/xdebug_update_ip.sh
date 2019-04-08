#!/usr/bin/env bash

# init the environment
.  `dirname "${THIS}"`"/bin/functions.sh"

HOST_IP_ADDRESS=$(docker network inspect --format "{{range .IPAM.Config}}{{.Gateway}}{{end}}" ${DOCKER_NETWORK_NAME} | sed -E 's/\/[0-9]{1,2}$//')

sed -e "s/\${main_host_ip_address}/${HOST_IP_ADDRESS}/" docker/magento2/config/xdebug_template.ini > docker/magento2/config/xdebug_new.ini

docker cp docker/magento2/config/xdebug_new.ini ${MAGENTO_CONTAINER_ID}:/usr/local/etc/php/conf.d/xdebug.ini

docker exec -i ${MAGENTO_CONTAINER_ID} /bin/bash -c "service apache2 restart"

rm docker/magento2/config/xdebug_new.ini
