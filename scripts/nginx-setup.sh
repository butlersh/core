#!/usr/bin/env bash

B_SCRIPTS_URL="https://raw.githubusercontent.com/butlersh/core/main/scripts"
B_CONFIG_URL="https://raw.githubusercontent.com/butlersh/core/main/config"

wget -qO- "$B_SCRIPTS_URL/pre-script.sh" | bash

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

B_USERNAME="forge"

for OPTION in "$@"
do
    NAME="$(cut -d'=' -f1 <<<"$OPTION")"
    VALUE="$(cut -d'=' -f2 <<<"$OPTION")"

    if [ "$NAME" = '--user' ]; then
        B_USERNAME="$VALUE"
    else
        echo "butlersh.ERROR: Unrecognized option $NAME"
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

wget -O fastcgi.conf "$B_CONFIG_URL/fastcgi.conf" --quiet
wget -O fastcgi-php.conf "$B_CONFIG_URL/fastcgi-php.conf" --quiet

mv fastcgi.conf /etc/nginx/extra/fastcgi.conf
mv fastcgi-php.conf /etc/nginx/extra/fastcgi-php.conf

sed -i "s/www-data/${B_USERNAME}/g" /etc/nginx/nginx.conf;

systemctl restart nginx
