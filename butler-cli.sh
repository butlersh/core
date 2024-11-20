#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

B_VERSION="main"
B_SCRIPTS_URL="https://raw.githubusercontent.com/confetticode/forge-like-setup/main/scripts"
B_USER="forge"
B_WEB="none"
B_MYSQL="none"
B_PHP="none"

echo_comment() {
  echo -e "\e[33m$1\e[0m"
}

echo_info() {
  echo -e "\e[32m$1\e[0m"
}

echo_comment_desc_line() {
  echo -e "  \e[32m$1\e[0m  $2"
}

user_setup() {
  wget -qO- "$B_SCRIPTS_URL/security-setup.sh" > security-setup.sh

  chmod +x security-setup.sh

  ./security-setup.sh --user="$1"

  rm -f security-setup.sh
}

nginx_setup() {
  wget -qO- "$B_SCRIPTS_URL/nginx-setup.sh" > nginx-setup.sh
  
  chmod +x nginx-setup.sh

  ./nginx-setup.sh --user="$1"

  rm -f nginx-setup.sh
}

mysql_setup() {
    wget -qO- "$B_SCRIPTS_URL/mysql-setup.sh" > mysql-setup.sh

    chmod +x mysql-setup.sh

    ./mysql-setup.sh --version="$1"

    rm -f mysql-setup.sh
}

php_setup() {
  wget -qO- "$B_SCRIPTS_URL/php-setup.sh" > php-setup.sh

  chmod +x php-setup.sh

  ./php-setup.sh --user="$1" --version="$2"

  rm -f php-setup.sh
}

help_butler() {
  echo -e "\e[32mButler CLI\e[0m version \e[33m$B_VERSION\e[0m"
  echo
  echo_comment "Description:"
  echo -e "  Running \"\e[32mbutler help [command]\"\e[0m to display the command details"
  echo
  echo_comment "Available commands:"
  echo -e "  \e[32mprovision\e[0m  Provision the current server"
}

help_provision() {
  echo_comment "Description:"
  echo "  Provision the current server"
  echo
  echo_comment "Options:"
  echo -e "  \e[32m--user=[USER]    \e[0m  The root alternative user"
  echo -e "  \e[32m--web=[WEBSERVER]\e[0m  The webserver, currently only nginx available"
  echo -e "  \e[32m--mysql=[version]\e[0m  The MySQL version (5.7 or 8.0)"
  echo -e "  \e[32m--php=[version]  \e[0m  The PHP version (7.1 -> 8.3)"
  echo
  echo_comment "Help:"
  echo "  This command can set up the LEMP stack"
  echo
  echo_info "    butler provision --user=forge --web=nginx  --mysql=8.0 --php=8.3"
  echo
  echo "  Or just create a root alternative user"
  echo
  echo_info "    butler provision --user=forge"
}

COMMAND=$1

case $COMMAND in
  "help")
    if [ "$2" = "provision" ]; then
      help_provision
      exit 0
    fi
    help_butler
    ;;

  "provision")
    for OPTION in "${@:2}"
    do
      NAME="$(cut -d'=' -f1 <<<"$OPTION")"
      VALUE="$(cut -d'=' -f2 <<<"$OPTION")"

      if [ "$NAME" = '--user' ]; then
          B_USER="$VALUE"
      elif [ "$NAME" = '--web' ]; then
          B_WEB="$VALUE"
      elif [ "$NAME" = '--mysql' ]; then
          B_MYSQL="$VALUE"
      elif [ "$NAME" = '--php' ]; then
          B_PHP="$VALUE"
      else
          NAME=''
          VALUE=''
          echo "Unrecognized option/argument $NAME"
          exit 1
      fi
    done
    user_setup "$B_USER"

    if [ "$B_WEB" != "nginx" ]; then
      nginx_setup "$B_WEB"
    fi

    if [ "$B_MYSQL" != "none" ]; then
      mysql_setup "$B_MYSQL"
    fi

    if [ "$B_PHP" != "none" ]; then
      php_setup "$B_USER" "$B_PHP"
    fi
    ;;

  *)
    help_butler
    ;;
esac
