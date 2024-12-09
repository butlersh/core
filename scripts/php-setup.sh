function run_php_setup() {
  B_USER="forge"
  B_GROUP="$B_USER"
  B_PHP_VERSION="$1"

  for OPTION in "$@"
  do
      NAME="$(cut -d'=' -f1 <<<"$OPTION")"
      VALUE="$(cut -d'=' -f2 <<<"$OPTION")"

      if [ "$NAME" = '--user' ]; then
          B_USER="$VALUE"
      elif [ "$NAME" = '--group' ]; then
          B_GROUP="$VALUE"
      elif [ "$NAME" = '--version' ]; then
          B_PHP_VERSION="$VALUE"
      else
          echo "butlersh.ERROR: Unrecognized option $NAME"
          exit 1
      fi
  done

  check_supported_os
  check_root_privileges

  locale-gen en_US.UTF-8
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8

  export DEBIAN_FRONTEND=noninteractive

  # TODO: Check if group exists.

  add-apt-repository -y ppa:ondrej/php

  apt-get update

  apt-get install -y \
      php"${B_PHP_VERSION}"-cli \
      php"${B_PHP_VERSION}"-curl \
      php"${B_PHP_VERSION}"-bcmath \
      php"${B_PHP_VERSION}"-fpm \
      php"${B_PHP_VERSION}"-gd \
      php"${B_PHP_VERSION}"-imap \
      php"${B_PHP_VERSION}"-intl \
      php"${B_PHP_VERSION}"-mbstring \
      php"${B_PHP_VERSION}"-mcrypt \
      php"${B_PHP_VERSION}"-mysql \
      php"${B_PHP_VERSION}"-pgsql \
      php"${B_PHP_VERSION}"-sqlite3 \
      php"${B_PHP_VERSION}"-xml \
      php"${B_PHP_VERSION}"-zip

  php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin/ --filename=composer

  # user = www-data
  sed -i "s/user = www-data/user = ${B_USER}/g" "/etc/php/${B_PHP_VERSION}/fpm/pool.d/www.conf";
  # group = www-data
  sed -i "s/group = www-data/group = ${B_GROUP}/g" "/etc/php/${B_PHP_VERSION}/fpm/pool.d/www.conf";

  # Change the pool name
  sed -i "s/\[www\]/\[PHP $B_PHP_VERSION\]/g" "/etc/php/$B_PHP_VERSION/fpm/pool.d/www.conf";

  systemctl restart php"${B_PHP_VERSION}"-fpm

  # Allow to run "sudo systemctl [reload|restart|status] php*-fpm" without password prompt.
  export PHP_FPM_ACTIONS="
  $B_USER ALL=(ALL) NOPASSWD: /usr/bin/systemctl reload php*-fpm
  $B_USER ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart php*-fpm
  $B_USER ALL=(ALL) NOPASSWD: /usr/bin/systemctl status php*-fpm"
  if ! echo "${PHP_FPM_ACTIONS}" | tee "/etc/sudoers.d/$B_USER"; then
      echo "butlersh.WARNING: Can not configure /etc/sudoers.d/$B_USER file. You have to configure it by yourself."
  fi
}
