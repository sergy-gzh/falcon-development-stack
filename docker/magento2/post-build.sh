#!/usr/bin/env bash

set -e

sudo chown www-data:www-data -R /var/www/html

if [ "$MAGENTO_DEV" == "Y" ]; then
    echo 'Magento from deity'
    composer install
else
    if [ ! -f "/var/www/html/composer.json" ]; then
        echo 'Magento from official magento repo'
        composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition /var/www/html/
    else
        echo 'Magento code exists'
    fi
fi

if [ ! -f /var/www/html/var/composer_home/auth.json ]; then
    if [ ! -d /var/www/html/var/composer_home/ ]; then
        mkdir /var/www/html/var/composer_home/
    fi
    ln -s  /var/www/.composer/auth.json /var/www/html/var/composer_home/auth.json 
fi

sudo find /var/www/html/ -type d -exec chmod 777 {} \; ## check this other-user rights, i'm setting this for the developer on the mounts
sudo find /var/www/html/ -type f -exec chmod 666 {} \; ## check this other-user rights, i'm setting this for the developer on the mounts
sudo chmod ugo+x /var/www/html/bin/magento
    
/usr/local/bin/install-magento

bin/magento  admin:user:create  --admin-user="${MAGENTO_NODEUSER_USERNAME}" --admin-password="${MAGENTO_NODEUSER_PASSWORD}" --admin-email="${MAGENTO_NODEUSER_EMAIL}" --admin-firstname="${MAGENTO_NODEUSER_FIRSTNAME}" --admin-lastname="${MAGENTO_NODEUSER_LASTNAME}"

/var/www/html/bin/magento deploy:mode:set developer

if [ "$MAGENTO_DEV" == "Y" ]; then
    echo "Develpoment mode. not installing modules (should already be in the installation)".
else
    composer config repositories.deity-api '{"type": "path", "url": "../packages/api"}'
    composer require deity/falcon-magento:dev-master
fi

/var/www/html/bin/magento sampledata:deploy 
/var/www/html/bin/magento setup:upgrade

sudo chown www-data:www-data -R /var/www/html
