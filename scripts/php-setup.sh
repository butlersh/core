#!/usr/bin/env bash

if [ "$USER" != 'root' ]; then
    echo 'root privileges required. Please run this script as root.'
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive

# TODO: Should be customizable.
C_USERNAME="forge"
C_PHP_VERSION="$1"

add-apt-repository -y ppa:ondrej/php

apt-get update

apt-get install -y \
    php"${C_PHP_VERSION}"-cli \
    php"${C_PHP_VERSION}"-curl \
    php"${C_PHP_VERSION}"-fpm \
    php"${C_PHP_VERSION}"-gd \
    php"${C_PHP_VERSION}"-imap \
    php"${C_PHP_VERSION}"-mbstring \
    php"${C_PHP_VERSION}"-mcrypt \
    php"${C_PHP_VERSION}"-mysql \
    php"${C_PHP_VERSION}"-pgsql \
    php"${C_PHP_VERSION}"-sqlite3 \
    php"${C_PHP_VERSION}"-xml \
    php"${C_PHP_VERSION}"-zip

php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

sed -i "s/www-data/${C_USERNAME}/g" "/etc/php/${C_PHP_VERSION}/fpm/pool.d/www.conf";

systemctl restart php"${C_PHP_VERSION}"-fpm
