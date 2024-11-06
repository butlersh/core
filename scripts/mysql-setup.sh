#!/usr/bin/env bash

# ./mysql-setup.sh --version=8.0

if [ "$USER" != 'root' ]; then
    echo '[error] root privileges required. Please run this script as root.'
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive

F_MYSQL_VERSION='8.0'

# TODO: Should be customizable.
F_MYSQL_PASSWORD="secret"

for OPTION in "$@"
do
    NAME="$(cut -d'=' -f1 <<<"$OPTION")"
    VALUE="$(cut -d'=' -f2 <<<"$OPTION")"

    if [ "$NAME" = '--version' ]; then
        F_MYSQL_VERSION="$VALUE"
    else
        echo "[error] Unrecognized option $NAME"
    fi
done

debconf-set-selections <<< "mysql-server mysql-server/root_password password ${F_MYSQL_PASSWORD}"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${F_MYSQL_PASSWORD}"

apt-get -y install mysql-server
