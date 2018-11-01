#!/usr/bin/env bash

set -e
sudo chown www-data:www-data -R /var/www/html

composer install

sudo find /var/www/html/ -type d -exec chmod 777 {} \; ## check this other-user rights, i'm setting this for the developer on the mounts
sudo find /var/www/html/ -type f -exec chmod 666 {} \; ## check this other-user rights, i'm setting this for the developer on the mounts
sudo chmod ugo+x /var/www/html/bin/magento
    
/usr/local/bin/install-magento

if [ ! -f /var/www/html/var/composer_home/auth.json ]; then
    if [ ! -d /var/www/html/var/composer_home/ ]; then
        mkdir /var/www/html/var/composer_home/
    fi
    ln -s  /var/www/.composer/auth.json /var/www/html/var/composer_home/auth.json 
fi

bin/magento  admin:user:create  --admin-user="${MAGENTO_NODEUSER_USERNAME}" --admin-password="${MAGENTO_NODEUSER_PASSWORD}" --admin-email="${MAGENTO_NODEUSER_EMAIL}" --admin-firstname="${MAGENTO_NODEUSER_FIRSTNAME}" --admin-lastname="${MAGENTO_NODEUSER_LASTNAME}"

/var/www/html/bin/magento deploy:mode:set developer

/var/www/html/bin/magento sampledata:deploy 
/var/www/html/bin/magento setup:upgrade

sudo chown www-data:www-data -R /var/www/html
