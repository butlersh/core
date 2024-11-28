#!/usr/bin/env bash

B_SCRIPTS_URL="https://raw.githubusercontent.com/butlersh/core/main/scripts"

wget -qO- "$B_SCRIPTS_URL/pre-script.sh" | bash

export DEBIAN_FRONTEND=noninteractive

B_MYSQL_VERSION='8.0'

# TODO: Should be customizable.
B_MYSQL_PASSWORD="secret"

for OPTION in "$@"
do
    NAME="$(cut -d'=' -f1 <<<"$OPTION")"
    VALUE="$(cut -d'=' -f2 <<<"$OPTION")"

    if [ "$NAME" = '--version' ]; then
        B_MYSQL_VERSION="$VALUE"
    else
        echo "butlersh.ERROR: Unrecognized argument/option $NAME."
        exit 1
    fi
done

mysql80 () {
    echo "butlersh.INFO: Start installing MySQL $B_MYSQL_VERSION"

    debconf-set-selections <<< "mysql-server mysql-server/root_password password ${B_MYSQL_PASSWORD}"
    debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${B_MYSQL_PASSWORD}"

    apt-get -y install mysql-server

    echo "butlersh.INFO: Finished installing MySQL $B_MYSQL_VERSION"

    mysql --version
}

case "$B_MYSQL_VERSION" in
    "8.0")
        mysql80
    ;;
    *)
        echo "butlersh.ERROR: Unsupported MySQL version $B_MYSQL_VERSION"
        exit 1
    ;;
esac
