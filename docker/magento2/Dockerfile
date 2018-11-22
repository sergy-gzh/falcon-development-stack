FROM alexcheng/apache2-php7:latest

ENV INSTALL_DIR /var/www/html
ENV COMPOSER_HOME /var/www/.composer/

COPY ./composer/auth.json $COMPOSER_HOME
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && mkdir /var/www/.ssh \
    && touch /var/www/.ssh/config \
    && echo "StrictHostKeyChecking no " >> /var/www/.ssh/config \
    && echo "StrictHostKeyChecking no " >> /root/.ssh/config \
    && chown www-data:www-data $COMPOSER_HOME/auth.json
   
#   && chown www-data:www-data /var/www/.ssh/* \
#   && chmod 400 /var/www/.ssh/id_rsa \


RUN requirements="libpng12-dev libmcrypt-dev libmcrypt4 libcurl3-dev libfreetype6 libjpeg-turbo8 libjpeg-turbo8-dev libpng12-dev libfreetype6-dev libicu-dev libxslt1-dev git" \
    && apt-get update \
    && apt-get install -y $requirements \
    && apt-get install -y sudo \
    && apt-get install -y mysql-client \
    && apt-get install -y unzip \
    && apt-get install -y ssmtp \
    && apt-get install -y mailutils \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install zip \
    && docker-php-ext-install intl \
    && docker-php-ext-install xsl \
    && docker-php-ext-install soap \
    && docker-php-ext-install bcmath \
    && requirementsToRemove="libpng12-dev libmcrypt-dev libcurl3-dev libpng12-dev libfreetype6-dev libjpeg-turbo8-dev" \
    && apt-get purge --auto-remove -y $requirementsToRemove

# PECL install but not enable xdebug
# Symlink xdebug.so so that it is at a known path
RUN pecl install xdebug \
    && PHP_EXT_PATH=$(php -r 'echo ini_get("extension_dir");') \
    && ln -s "${PHP_EXT_PATH}/xdebug.so" /opt/xdebug.so \
    && chsh -s /bin/bash www-data \
    && chown -R www-data:www-data /var/www

COPY ./config/redis_config.txt /var/www/redis_config.txt
COPY ./config/xdebug.ini /usr/local/etc/php/conf.d/
COPY ./install-magento /usr/local/bin/install-magento
COPY ./post-build.sh /usr/local/bin/post-build.sh

RUN chmod +x /usr/local/bin/post-build.sh \
&& chmod +x /usr/local/bin/install-magento \
&&  a2enmod rewrite \
&&  echo "memory_limit=2048M" > /usr/local/etc/php/conf.d/memory-limit.ini \
&&  echo "www-data ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
&&  echo "hostname=localhost.localdomain" >> /etc/ssmtp/ssmtp.conf \
&&  echo "root=root@deity.io" >> /etc/ssmtp/ssmtp.conf \
&&  echo "mailhub=deity_mailhog:1025" >> /etc/ssmtp/ssmtp.conf \
&&  echo "sendmail_path=/usr/sbin/ssmtp -t" >> /usr/local/etc/php/conf.d/php-sendmail.ini \
&&  echo "localhost localhost.localdomain" >> /etc/hosts \
&&  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR $INSTALL_DIR

# Add cron job
ADD crontab /etc/cron.d/magento2-cron
RUN chmod 0644 /etc/cron.d/magento2-cron \
    && crontab -u www-data /etc/cron.d/magento2-cron
