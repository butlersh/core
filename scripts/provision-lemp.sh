#!/usr/bin/env bash

# ./security-setup.sh --user=forge --php=8.3 --mysql=8.0

if [ "$USER" != 'root' ]; then
    echo '[error] root privileges required. Please run this script as root.'
    exit 1
fi

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
        echo "[error] Unrecognized option $NAME"
        exit 1
    fi
done

mkdir -p /root/provision/

cd /root/provision/ || exit

echo 'Download scripts'

wget -O security-setup.sh https://raw.githubusercontent.com/confetticode/forge-like-setup/main/scripts/security-setup.sh --quiet
wget -O nginx-setup.sh https://raw.githubusercontent.com/confetticode/forge-like-setup/main/scripts/nginx-setup.sh --quiet
wget -O php-setup.sh https://raw.githubusercontent.com/confetticode/forge-like-setup/main/scripts/php-setup.sh --quiet
wget -O mysql-setup.sh https://raw.githubusercontent.com/confetticode/forge-like-setup/main/scripts/mysql-setup.sh --quiet

chmod +x *-setup.sh

echo 'Run security-setup.sh'
./security-setup.sh --user="$F_USERNAME"

echo 'Run nginx-setup.sh'
./nginx-setup.sh --user="$F_USERNAME"

echo 'Run php-setup.sh'
./php-setup.sh --user="$F_USERNAME" --version="$F_PHP_VERSION"

echo 'Run mysql-setup.sh'
./mysql-setup.sh --version="$F_MYSQL_VERSION"

rm -rf "*-setup.sh"
