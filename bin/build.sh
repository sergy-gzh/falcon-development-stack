#!/usr/bin/env bash

set -a
set -e

source ./docker/magento2/env

# then run all the commands needed to be doen befoure the docker build
. "bin/pre_build.sh"

# Do the docker build

docker-compose build

# Now run all the commands that would change data on the mounted volues 
. "bin/post_build.sh"

color_green
echo "Build is done"
echo "bringing down environment. To start it up again type bin/up.sh "
color_reset

docker-compose down
