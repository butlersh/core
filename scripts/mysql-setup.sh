#!/usr/bin/env bash

if [ "$USER" != 'root' ]; then
    echo 'root privileges required. Please run this script as root.'
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive

# TODO: Should be customizable.
C_MYSQL_PASSWORD="secret"

debconf-set-selections <<< "mysql-server mysql-server/root_password password ${C_MYSQL_PASSWORD}"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${C_MYSQL_PASSWORD}"

apt-get -y install mysql-server
