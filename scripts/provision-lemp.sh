#!/usr/bin/env bash

if [ "$USER" != 'root' ]; then
    echo 'root privileges required. Please run this script as root.'
    exit 1
fi

mkdir -p /root/provision/

cd /root/provision/ || exit

wget -O security-setup.sh https://raw.githubusercontent.com/confetticode/forge-like-setup/provision-lemp/scripts/security-setup.sh
wget -O nginx-setup.sh https://raw.githubusercontent.com/confetticode/forge-like-setup/provision-lemp/scripts/nginx-setup.sh
wget -O php-setup.sh https://raw.githubusercontent.com/confetticode/forge-like-setup/provision-lemp/scripts/php-setup.sh
wget -O mysql-setup.sh https://raw.githubusercontent.com/confetticode/forge-like-setup/provision-lemp/scripts/mysql-setup.sh

bash security-setup.sh
bash nginx-setup.sh
bash php-setup.sh 8.3
bash mysql-setup.sh

rm -rf "*-setup.sh"
