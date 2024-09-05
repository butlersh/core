#!/usr/bin/env bash

SUDO_USER="forge"
PHP_VERSION="$1"

add-apt-repository -y ppa:ondrej/php

apt-get update

apt-get install -y software-properties-common curl git unzip zip

apt-get install -y \
    php"${PHP_VERSION}"-cli \
    php"${PHP_VERSION}"-curl \
    php"${PHP_VERSION}"-fpm \
    php"${PHP_VERSION}"-gd \
    php"${PHP_VERSION}"-imap \
    php"${PHP_VERSION}"-mbstring \
    php"${PHP_VERSION}"-mcrypt \
    php"${PHP_VERSION}"-mysql \
    php"${PHP_VERSION}"-pgsql \
    php"${PHP_VERSION}"-sqlite3 \
    php"${PHP_VERSION}"-xml

php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

sed -i "s/www-data/${SUDO_USER}/g" "/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf";

systemctl restart php"${PHP_VERSION}"-fpm
