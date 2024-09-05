#!/usr/bin/env bash

SUDO_USER="forge"

sudo apt-get install -y nginx

if [ -d /etc/nginx ]; then
  rm -rf /etc/nginx.old

  sudo mv /etc/nginx /etc/nginx.old

  git clone https://github.com/h5bp/server-configs-nginx.git /etc/nginx
fi

mkdir -p /etc/nginx/extra

wget -O fastcgi.conf https://raw.githubusercontent.com/confetticode/forge-like-setup/main/etc/fastcgi.conf
wget -O fastcgi-php.conf https://raw.githubusercontent.com/confetticode/forge-like-setup/main/etc/fastcgi-php.conf

mv fastcgi.conf /etc/nginx/extra/fastcgi.conf
mv fastcgi-php.conf /etc/nginx/extra/fastcgi-php.conf

sed -i "s/www-data/${SUDO_USER}/g" /etc/nginx/nginx.conf;
