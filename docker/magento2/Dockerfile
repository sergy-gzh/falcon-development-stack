FROM php:7.4-fpm-buster
MAINTAINER Sergii Gozhedrianov <sergii@deity.io>

ENV COMPOSER_HOME /var/www/.composer/

RUN apt-get update && apt-get install -y \
  cron \
  git \
  gzip \
  libbz2-dev \
  libfreetype6-dev \
  libicu-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  libonig-dev \
  libpng-dev \
  libsodium-dev \
  libssh2-1-dev \
  libxslt1-dev \
  libzip-dev \
  lsof \
  default-mysql-client \
  vim \
  zip \
  procps

RUN docker-php-ext-configure gd --with-freetype --with-jpeg

RUN docker-php-ext-install \
  bcmath \
  bz2 \
  calendar \
  exif \
  gd \
  gettext \
  intl \
  mbstring \
  mysqli \
  opcache \
  pcntl \
  pdo_mysql \
  soap \
  sockets \
  sodium \
  sysvmsg \
  sysvsem \
  sysvshm \
  xsl \
  zip

# PECL install but not enable xdebug
# Symlink xdebug.so so that it is at a known path
RUN pecl channel-update pecl.php.net \
  && pecl install xdebug \
  && PHP_EXT_PATH=$(php -r 'echo ini_get("extension_dir");') \
  && ln -s "${PHP_EXT_PATH}/xdebug.so" /opt/xdebug.so \
  && chsh -s /bin/bash www-data \
  && chown -R www-data:www-data /var/www

RUN groupadd -g 1000 app \
    && useradd -g 1000 -u 1000 -d /var/www -s /bin/bash app

RUN curl -sSLO https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 \
  && chmod +x mhsendmail_linux_amd64 \
  && mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail

RUN curl -sS https://getcomposer.org/installer | \
  php -- --version=1.10.10 --install-dir=/usr/local/bin --filename=composer

COPY config/www.conf /usr/local/etc/php-fpm.d/
COPY config/php.ini /usr/local/etc/php/
COPY config/php-fpm.conf /usr/local/etc/

RUN mkdir -p /etc/nginx/html /var/www/html /sock \
  && chown -R app:app /etc/nginx /var/www /usr/local/etc/php/conf.d /sock

USER app:app

VOLUME /var/www

WORKDIR /var/www/html