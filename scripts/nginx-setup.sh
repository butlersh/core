#!/usr/bin/env bash

# ./nginx-setup.sh --user=forge

wget -O pre-script.sh https://raw.githubusercontent.com/confetticode/forge-like-setup/pre-script/scripts/pre-script.sh --quiet

chmod +x pre-script.sh

./pre-script.sh

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

F_USERNAME="forge"

for OPTION in "$@"
do
    NAME="$(cut -d'=' -f1 <<<"$OPTION")"
    VALUE="$(cut -d'=' -f2 <<<"$OPTION")"

    if [ "$NAME" = '--user' ]; then
        F_USERNAME="$VALUE"
    else
        echo "[forge.ERROR] Unrecognized option $NAME"
        exit 1
    fi
done

# Install nginx with certbot to use free SSL via Letsencrypt.
apt-get install -y nginx certbot python3-certbot-nginx

if [ -d /etc/nginx ]; then
  rm -rf /etc/nginx.old

  mv /etc/nginx /etc/nginx.old
fi

git clone https://github.com/h5bp/server-configs-nginx.git /etc/nginx

mkdir -p /etc/nginx/extra

wget -O fastcgi.conf https://raw.githubusercontent.com/confetticode/forge-like-setup/pre-script/etc/fastcgi.conf --quiet
wget -O fastcgi-php.conf https://raw.githubusercontent.com/confetticode/forge-like-setup/pre-script/etc/fastcgi-php.conf --quiet

mv fastcgi.conf /etc/nginx/extra/fastcgi.conf
mv fastcgi-php.conf /etc/nginx/extra/fastcgi-php.conf

sed -i "s/www-data/${F_USERNAME}/g" /etc/nginx/nginx.conf;

systemctl restart nginx
