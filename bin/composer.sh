#!/usr/bin/env bash
set -a
docker exec -it -u www-data $(docker container ls -q --filter name=deity_magento2_1) /bin/bash -c "/usr/local/bin/composer $@"
