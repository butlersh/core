#!/usr/bin/env bash

# ./mysql-setup.sh --version=8.0

if [ "$USER" != 'root' ]; then
    echo '[forge.ERROR]: root privileges required. Please run this script as root.'
    exit 1
fi

OS_DESC="$(lsb_release -a | grep 'Description' | awk '{print $2 " "  $3}')"

case "$OS_DESC" in
    "Ubuntu 24.04")
        # If the OS is supported, it just continue this script.
    ;;
    *)
        echo "[forge.ERROR] Unsupported OS, currently supported Ubuntu 24.04"
    ;;
esac

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
        echo "[forge.ERROR] Unrecognized argument/option $NAME."
        exit 1
    fi
done

mysql80 () {
    echo "[forge.INFO] Start installing MySQL $F_MYSQL_VERSION"

    debconf-set-selections <<< "mysql-server mysql-server/root_password password ${F_MYSQL_PASSWORD}"
    debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${F_MYSQL_PASSWORD}"

    apt-get -y install mysql-server

    echo "[forge.INFO] Finished installing MySQL $F_MYSQL_VERSION"

    mysql --version
}

case "$F_MYSQL_VERSION" in
    "8.0")
        mysql80
    ;;
    *)
        echo "[forge.ERROR] Unsupported MySQL version $F_MYSQL_VERSION"
        exit 1
    ;;
esac
