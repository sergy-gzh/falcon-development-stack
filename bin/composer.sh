#!/usr/bin/env bash
set -a
docker exec -it -u app $(docker container ls -q --filter name=magento2_phpfpm) /bin/bash -c "/usr/local/bin/composer $@"
#docker exec -it  $(docker container ls -q --filter name=deity_magento2_1) /bin/bash -c "/usr/local/bin/composer $@"
