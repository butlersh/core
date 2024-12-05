#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

B_VERSION="dev-main"
B_SCRIPTS_URL="https://raw.githubusercontent.com/butlersh/core/main/scripts"

command_help() {
  echo -e "\e[33mDescription:\e[0m"
  echo "  Display help for a command"
}

command_list() {
  echo -e "\e[32mButlersh CLI\e[0m version \e[33m$B_VERSION\e[0m"
  echo
  echo -e "\e[33mUsage:\e[0m"
  echo "  command [options] [arguments]"
  echo
  echo -e "\e[33mOptions:\e[0m"
  echo -e "  \e[32m-h,\e[0m \e[32m--help\e[0m         Display help for the given command. When no command is given display help for the \e[33mlist\e[0m command"
  echo -e "  \e[32m-V,\e[0m \e[32m--version\e[0m      Display this application version"
  echo
  echo -e "\e[33mAvailable commands:\e[0m"
  echo -e "  \e[32msetup:security\e[0m  Set up security for a fresh server"
}

command_setup_security() {
  if [ -f ./scripts/security-setup.sh ]; then
    ./scripts/security-setup.sh "$@"
  else
    mkdir -p /var/lib/butlersh/scripts

    rm -f /var/lib/butlersh/scripts/security-setup.sh

    wget -qO- "$B_SCRIPTS_URL/security-setup.sh" > /var/lib/butlersh/scripts/security-setup.sh

    bash /var/lib/butlersh/scripts/security-setup.sh "$@"
  fi
}

for OPTION in "$@"
do
    NAME="$(cut -d'=' -f1 <<<"$OPTION")"

    if [ "$NAME" = '--version' ]; then
        echo -e "\e[32mButlersh CLI\e[0m version \e[33m$B_VERSION\e[0m"
        exit 0
    fi
done

COMMAND=$1

shift

case $COMMAND in
  "help")
    if [ "$2" = "setup:security" ]; then
      B_VERSION="$B_VERSION" command_setup_security --help
      exit 0
    fi
    B_VERSION="$B_VERSION" command_help
    exit 0
    ;;

  "setup:security")
    B_VERSION="$B_VERSION" command_setup_security "$@"
    ;;

  *)
    B_VERSION="$B_VERSION" command_list
    ;;
esac
