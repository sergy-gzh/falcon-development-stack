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
docker-compose exec -u www-data deity_magento2 /bin/bash /usr/local/bin/post-build.sh

color_magenta
echo "Updating deity server config"
color_reset 
docker-compose up -d deity_project
docker-compose exec deity_project /bin/sh -c "mv /usr/server_default.json /usr/src/my-app/server/config/default.json"
