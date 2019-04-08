#!/usr/bin/env bash
set -e
set -a

# init the environment
.  `dirname "${THIS}"`"/bin/functions.sh"

TEST_TYPE=$1
if [ -z "$TEST_TYPE" ]; then
    echo "Specify type of test you want to run."
    exit 1
fi

case $TEST_TYPE in
unit)
    CONFIG_FILE_PATH='/var/www/html/dev/tests/unit'
    ;;
static)
    CONFIG_FILE_PATH='/var/www/html/dev/tests/static'
    ;;
integration)
    CONFIG_FILE_PATH='/var/www/html/dev/tests/integration'
    ;;
api)
    CONFIG_FILE_PATH='/var/www/html/dev/tests/api-functional'
    ;;
*)
    echo "Given test type is not supported"
    exit 1
esac

# drop the first parameter, its not needed anymore
shift

docker exec -it -u www-data ${MAGENTO_CONTAINER_ID} /bin/bash -c "php /var/www/html/vendor/bin/phpunit -c $CONFIG_FILE_PATH  $@"
#docker exec -it -u www-data $(docker container ls -q --filter name=deity_magento2_1) /bin/bash -c "PHP_IDE_CONFIG='serverName=falcon.local' php -d xdebug.remote_autostart=1 /var/www/html/vendor/bin/phpunit -c $CONFIG_FILE_PATH $@"
# --filter 'Deity\\\CatalogApi\\\Test\\\Api\\\GetProductsTest::testGetList'
