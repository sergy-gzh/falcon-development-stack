#!/usr/bin/env bash
set -a
source ./docker/magento2/env
docker-compose up -d

# change ownership of the ssh agent socket so www-data can use it
# must be done on every startup because the host volume must be mounted
#docker-compose exec deity_magento2 /bin/sh -c 'chown www-data:www-data /tmp/agent.sock'

# wait to start node server until wordpress responds
docker-compose exec deity_project /bin/sh -c 'wait-for-ok.sh "http://wordpress/wp-json/wp/v2/blog/info" 15 && cd /usr/src/my-app/server  && yarn start'
