#!/usr/bin/env bash

if [ "$USER" != 'root' ]; then
    echo 'root privileges required. Please run this script as root.'
    exit 1
fi

# TODO: Should be customizable.
C_USERNAME="forge"

apt-get install -y nginx

if [ -d /etc/nginx ]; then
  rm -rf /etc/nginx.old

  mv /etc/nginx /etc/nginx.old
fi

git clone https://github.com/h5bp/server-configs-nginx.git /etc/nginx

mkdir -p /etc/nginx/extra

wget -O fastcgi.conf https://raw.githubusercontent.com/confetticode/forge-like-setup/main/etc/fastcgi.conf
wget -O fastcgi-php.conf https://raw.githubusercontent.com/confetticode/forge-like-setup/main/etc/fastcgi-php.conf

mv fastcgi.conf /etc/nginx/extra/fastcgi.conf
mv fastcgi-php.conf /etc/nginx/extra/fastcgi-php.conf

sed -i "s/www-data/${C_USERNAME}/g" /etc/nginx/nginx.conf;
