#!/usr/bin/env bash

##################################################################################
##
##   POST-Build runs the commands that could not be run in the default Dockerfile,
##                        because the depend on the mounted volumes 
##
##################################################################################

# init the environment 
.  `dirname "${THIS}"`"/bin/functions.sh"

color_magenta
echo "Installing wordpress"
color_reset 

docker-compose up -d deity_wordpress
docker-compose exec deity_wordpress /bin/bash /usr/local/bin/post-build.sh

color_magenta
echo "Installing magento"
color_reset 
# change ownership of the ssh agent socket so www-data can use it
docker-compose up -d deity_magento2
#docker-compose exec deity_magento2 /bin/sh -c 'chown www-data:www-data /tmp/agent.sock'

docker-compose exec deity_magento2 /bin/bash -c "chown -R www-data:www-data ${MAGENTO_DIR}"
docker exec -it -u www-data $(docker container ls -q --filter name=deity_magento2_1) /bin/bash /usr/local/bin/post-build.sh

color_magenta
echo "Updating deity server config"
color_reset
docker-compose run  deity_server /bin/sh -c "cp /usr/server_development.json /usr/src/my-app/server/config/development.json"


color_magenta
echo "Updating deity client config"
color_reset 
docker-compose run deity_client  /bin/sh -c "cp /usr/client_development.json /usr/src/my-app/client/config/development.json"
