help_nginx_setup_command() {
  io_comment 'Description:'
  io_line '  Set up Nginx for the current server'
  io_line

  io_comment 'Usage:'
  io_line '  nginx:setup [options]'
  io_line

  io_comment 'Options:'
  io_line '  <success>    --user=USER</success>  The user is for running nginx workers <comment>[default: "forge"]</comment>'
  io_line '  <success>-h, --help</success>       Display help for the given command. When no command is given, display help for the <success>list</success> command'
  io_line '  <success>-V, --version</success>    Display this application version'

  exit 0
}

run_nginx_setup_command() {
  B_CONFIG_URL="https://raw.githubusercontent.com/butlersh/core/build/config"
  B_USER="forge"

  for OPTION in "$@"
  do
      NAME="$(cut -d'=' -f1 <<<"$OPTION")"
      VALUE="$(cut -d'=' -f2 <<<"$OPTION")"

      if [ "$NAME" = '--user' ]; then
          B_USER="$VALUE"
      fi
  done

  check_supported_os
  check_root_privileges

  export DEBIAN_FRONTEND=noninteractive
  export NEEDRESTART_MODE=a

  add-apt-repository -y ppa:ondrej/nginx

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

  sed -i "s/www-data/${B_USER}/g" /etc/nginx/nginx.conf;

  systemctl restart nginx
}
