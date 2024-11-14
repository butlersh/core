#!/usr/bin/env bash

F_SCRIPTS_URL="https://raw.githubusercontent.com/confetticode/forge-like-setup/main/scripts"

wget -qO- "$F_SCRIPTS_URL/pre-script.sh" | bash

# ./provision-lemp.sh --user=forge --php=8.3 --mysql=8.0

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

F_USERNAME=forge
F_PHP_VERSION=8.3
F_MYSQL_VERSION=8.0

for OPTION in "$@"
do
    NAME="$(cut -d'=' -f1 <<<"$OPTION")"
    VALUE="$(cut -d'=' -f2 <<<"$OPTION")"

    if [ "$NAME" = '--user' ]; then
        F_USERNAME="$VALUE"
    elif [ "$NAME" = '--php' ]; then
        F_PHP_VERSION="$VALUE"
    elif [ "$NAME" = '--mysql' ]; then
        F_MYSQL_VERSION="$VALUE"
    else
        echo "[forge.ERROR] Unrecognized option $NAME"
        exit 1
    fi
done

mkdir -p /root/provision/

cd /root/provision/ || exit 1

echo '[forge.INFO] Download setup scripts'

wget -qO- "$F_SCRIPTS_URL/security-setup.sh" > security-setup.sh
wget -qO- "$F_SCRIPTS_URL/nginx-setup.sh" > nginx-setup.sh
wget -qO- "$F_SCRIPTS_URL/php-setup.sh" > php-setup.sh
wget -qO- "$F_SCRIPTS_URL/mysql-setup.sh" > mysql-setup.sh

chmod +x *.sh

echo '[forge.INFO] Run security-setup.sh'
./security-setup.sh --user="$F_USERNAME"

echo '[forge.INFO] Run nginx-setup.sh'
./nginx-setup.sh --user="$F_USERNAME"

echo '[forge.INFO] Run php-setup.sh'
./php-setup.sh --user="$F_USERNAME" --version="$F_PHP_VERSION"

echo '[forge.INFO] Run mysql-setup.sh'
./mysql-setup.sh --version="$F_MYSQL_VERSION"

echo '[forge.INFO] Remove setup scripts'
rm -rf "*-setup.sh"

cd /root || exit 1

rm -rf provision
