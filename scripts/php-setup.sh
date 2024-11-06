#!/usr/bin/env bash

# ./php-setup.sh --user=forge --version=8.3

if [ "$USER" != 'root' ]; then
    echo '[error] root privileges required. Please run this script as root.'
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive

F_USERNAME="forge"
F_PHP_VERSION="$1"

for OPTION in "$@"
do
    NAME="$(cut -d'=' -f1 <<<"$OPTION")"
    VALUE="$(cut -d'=' -f2 <<<"$OPTION")"

    if [ "$NAME" = '--user' ]; then
        F_USERNAME="$VALUE"
    elif [ "$NAME" = '--version' ]; then
        F_PHP_VERSION="$VALUE"
    else
        echo "[error] Unrecognized option $NAME"
    fi
done

add-apt-repository -y ppa:ondrej/php

apt-get update

apt-get install -y \
    php"${F_PHP_VERSION}"-cli \
    php"${F_PHP_VERSION}"-curl \
    php"${F_PHP_VERSION}"-fpm \
    php"${F_PHP_VERSION}"-gd \
    php"${F_PHP_VERSION}"-imap \
    php"${F_PHP_VERSION}"-mbstring \
    php"${F_PHP_VERSION}"-mcrypt \
    php"${F_PHP_VERSION}"-mysql \
    php"${F_PHP_VERSION}"-pgsql \
    php"${F_PHP_VERSION}"-sqlite3 \
    php"${F_PHP_VERSION}"-xml \
    php"${F_PHP_VERSION}"-zip

php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

sed -i "s/www-data/${F_USERNAME}/g" "/etc/php/${F_PHP_VERSION}/fpm/pool.d/www.conf";
#sed -i "s/www-data/[www]/g" "/etc/php/[PHP ${F_PHP_VERSION}]/fpm/pool.d/www.conf";

systemctl restart php"${F_PHP_VERSION}"-fpm

# Allows forge to run "sudo systemctl [reload|restart|status] php*-fpm" without password prompt.
export FORGE_PHP_FPM_ACTIONS="
forge ALL=(ALL) NOPASSWD: /usr/bin/systemctl reload php*-fpm
forge ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart php*-fpm
forge ALL=(ALL) NOPASSWD: /usr/bin/systemctl status php*-fpm"
if ! echo "${FORGE_PHP_FPM_ACTIONS}" | tee "/etc/sudoers.d/$F_USERNAME"; then
    echo "[warning] Can not configure /etc/sudoers.d/$F_USERNAME file. You have to configure it by yourself."
fi
