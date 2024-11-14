#!/usr/bin/env bash

F_SCRIPTS_URL="https://raw.githubusercontent.com/confetticode/forge-like-setup/main/scripts"

wget -qO- "$F_SCRIPTS_URL/pre-script.sh" | bash

# ./php-setup.sh --user=forge --version=8.3

locale-gen en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

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
        echo "[forge.ERROR] Unrecognized option $NAME"
        exit 1
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

# user = forge
# group = forge
sed -i "s/www-data/${F_USERNAME}/g" "/etc/php/${F_PHP_VERSION}/fpm/pool.d/www.conf";

# Change the pool name
sed -i "s/\[www\]/\[PHP $F_PHP_VERSION\]/g" "/etc/php/$F_PHP_VERSION/fpm/pool.d/www.conf";

systemctl restart php"${F_PHP_VERSION}"-fpm

# Allows forge to run "sudo systemctl [reload|restart|status] php*-fpm" without password prompt.
export FORGE_PHP_FPM_ACTIONS="
forge ALL=(ALL) NOPASSWD: /usr/bin/systemctl reload php*-fpm
forge ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart php*-fpm
forge ALL=(ALL) NOPASSWD: /usr/bin/systemctl status php*-fpm"
if ! echo "${FORGE_PHP_FPM_ACTIONS}" | tee "/etc/sudoers.d/$F_USERNAME"; then
    echo "[warning] Can not configure /etc/sudoers.d/$F_USERNAME file. You have to configure it by yourself."
fi
