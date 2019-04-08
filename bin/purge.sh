#!/usr/bin/env bash

rm -rf src/magento2/
rm -rf src/deity-project/

rm -rf src/deity-wordpress-api/
rm -rf src/deity-products-wordpress/

rm -f docker/magento2/composer/auth.json
rm -f docker/magento2/.ssh/id_rsa

docker-compose down -v

