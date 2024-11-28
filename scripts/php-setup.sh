#!/usr/bin/env bash

B_SCRIPTS_URL="https://raw.githubusercontent.com/butlersh/core/main/scripts"

wget -qO- "$B_SCRIPTS_URL/pre-script.sh" | bash

locale-gen en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export DEBIAN_FRONTEND=noninteractive

B_USERNAME="forge"
B_PHP_VERSION="$1"

for OPTION in "$@"
do
    NAME="$(cut -d'=' -f1 <<<"$OPTION")"
    VALUE="$(cut -d'=' -f2 <<<"$OPTION")"

    if [ "$NAME" = '--user' ]; then
        B_USERNAME="$VALUE"
    elif [ "$NAME" = '--version' ]; then
        B_PHP_VERSION="$VALUE"
    else
        echo "butlersh.ERROR: Unrecognized option $NAME"
        exit 1
    fi
done

add-apt-repository -y ppa:ondrej/php

apt-get update

apt-get install -y \
    php"${B_PHP_VERSION}"-cli \
    php"${B_PHP_VERSION}"-curl \
    php"${B_PHP_VERSION}"-fpm \
    php"${B_PHP_VERSION}"-gd \
    php"${B_PHP_VERSION}"-imap \
    php"${B_PHP_VERSION}"-mbstring \
    php"${B_PHP_VERSION}"-mcrypt \
    php"${B_PHP_VERSION}"-mysql \
    php"${B_PHP_VERSION}"-pgsql \
    php"${B_PHP_VERSION}"-sqlite3 \
    php"${B_PHP_VERSION}"-xml \
    php"${B_PHP_VERSION}"-zip

php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

# user = forge
# group = forge
sed -i "s/www-data/${B_USERNAME}/g" "/etc/php/${B_PHP_VERSION}/fpm/pool.d/www.conf";

# Change the pool name
sed -i "s/\[www\]/\[PHP $B_PHP_VERSION\]/g" "/etc/php/$B_PHP_VERSION/fpm/pool.d/www.conf";

systemctl restart php"${B_PHP_VERSION}"-fpm

# Allows forge to run "sudo systemctl [reload|restart|status] php*-fpm" without password prompt.
export FORGE_PHP_FPM_ACTIONS="
forge ALL=(ALL) NOPASSWD: /usr/bin/systemctl reload php*-fpm
forge ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart php*-fpm
forge ALL=(ALL) NOPASSWD: /usr/bin/systemctl status php*-fpm"
if ! echo "${FORGE_PHP_FPM_ACTIONS}" | tee "/etc/sudoers.d/$B_USERNAME"; then
    echo "[warning] Can not configure /etc/sudoers.d/$B_USERNAME file. You have to configure it by yourself."
fi
