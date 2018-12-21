#!/usr/bin/env bash

set -e

sudo chown www-data:www-data -R ${MAGENTO_DIR}

if [ "$MAGENTO_DEV" == "Y" ]; then
    echo 'Magento from deity'
    composer install
else
    if [ ! -e "${MAGENTO_DIR}/composer.json" ]; then
        echo 'Magento from official magento repo'
        composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition="${MAGENTO_VERSION_BRANCH_NAME}" ${MAGENTO_DIR}/
    else
        echo 'Magento code exists'
    fi
fi

if [ ! -f ${MAGENTO_DIR}/var/composer_home/auth.json ]; then
    if [ ! -d ${MAGENTO_DIR}/var/composer_home/ ]; then
        mkdir ${MAGENTO_DIR}/var/composer_home/
    fi
    ln -s  /var/www/.composer/auth.json ${MAGENTO_DIR}/var/composer_home/auth.json
fi

sudo find ${MAGENTO_DIR}/ -type d -exec chmod 777 {} \; ## check this other-user rights, i'm setting this for the developer on the mounts
sudo find ${MAGENTO_DIR}/ -type f -exec chmod 666 {} \; ## check this other-user rights, i'm setting this for the developer on the mounts
sudo chmod ugo+x ${MAGENTO_DIR}/bin/magento
sudo chmod ugo+x ${MAGENTO_DIR}/vendor/bin/*

/usr/local/bin/install-magento

${MAGENTO_DIR}/bin/magento  admin:user:create  --admin-user="${MAGENTO_NODEUSER_USERNAME}" --admin-password="${MAGENTO_NODEUSER_PASSWORD}" --admin-email="${MAGENTO_NODEUSER_EMAIL}" --admin-firstname="${MAGENTO_NODEUSER_FIRSTNAME}" --admin-lastname="${MAGENTO_NODEUSER_LASTNAME}"

${MAGENTO_DIR}/bin/magento deploy:mode:set developer

if [ "$MAGENTO_DEV" == "Y" ]; then
    echo "Develpoment mode. not installing modules (should already be in the installation)".
else
    composer require deity/falcon-magento dev-master
fi

if [ "$MAGENTO_DEV" != "Y" ]; then
    # Its impossible to run sample data and magento API tests altogether.
    ${MAGENTO_DIR}/bin/magento sampledata:deploy
    ${MAGENTO_DIR}/bin/magento setup:upgrade
fi

sudo chown www-data:www-data -R ${MAGENTO_DIR}

if [ "$MAGENTO_DEV" != "Y" ]; then
    ${MAGENTO_DIR}/bin/magento deploy:mode:set production
fi
