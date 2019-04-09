#!/usr/bin/env bash

set -e

if [ "$MAGENTO_DEV" == "Y" ]; then
    echo 'Magento from deity'
    composer global require hirak/prestissimo
    composer install
else
    if [ ! -e "${MAGENTO_DIR}/composer.json" ]; then
        echo 'Installing Magento from repo'
        composer create-project --repository=https://repo-magento-mirror.fooman.co.nz/ magento/project-community-edition="${MAGENTO_VERSION_BRANCH_NAME}" ${MAGENTO_DIR} --no-install
        cd ${MAGENTO_DIR}
        composer config --unset repo.0
        composer config repo.foomanmirror composer https://repo-magento-mirror.fooman.co.nz/
        echo 'Preparing to install done'
        composer install
        cd ../
    else
        echo 'Magento code exists'
    fi
fi

find ${MAGENTO_DIR}/ -type d -exec chmod 777 {} \; ## check this other-user rights, i'm setting this for the developer on the mounts
find ${MAGENTO_DIR}/ -type f -exec chmod 666 {} \; ## check this other-user rights, i'm setting this for the developer on the mounts
chmod ugo+x ${MAGENTO_DIR}/bin/magento
chmod ugo+x ${MAGENTO_DIR}/vendor/bin/*

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

if [ "$MAGENTO_DEV" != "Y" ]; then
    ${MAGENTO_DIR}/bin/magento deploy:mode:set production
fi
