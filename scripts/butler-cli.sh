#!/usr/bin/env bash

COMMAND=$1

case $COMMAND in
  "help")
    echo "Butler CLI dev-main"
    echo
    echo "  provision  Provision the current server. (E.g: butler provision --user=forge --mysql=8.0 --php=8.3)"
    echo
    ;;

  "provision")
    for OPTION in "${@:2}"
    do
      F_USER="forge"
      F_MYSQL="8.0"
      F_PHP="8.3"

      NAME="$(cut -d'=' -f1 <<<"$OPTION")"
      VALUE="$(cut -d'=' -f2 <<<"$OPTION")"

      if [ "$NAME" = '--user' ]; then
          F_USER="$VALUE"
      elif [ "$NAME" = '--mysql' ]; then
          F_MYSQL="$VALUE"
      elif [ "$NAME" = '--php' ]; then
          F_PHP="$VALUE"
      else
          echo "Unrecognized option/argument $NAME"
          exit 1
      fi
    done
    wget -qO- "https://raw.githubusercontent.com/confetticode/forge-like-setup/main/scripts/provision-lemp.sh" > /tmp/provision-lemp.sh
    bash /tmp/provision-lemp.sh --user="$F_USER" --mysql="$F_MYSQL" --php="$F_PHP"
    ;;

  *)
    echo "Missing command. Please run \"butler help\" for more details"
    exit 1
    ;;
esac
