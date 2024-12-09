B_VERSION="dev-main"

command_help() {
  echo -e "\e[33mDescription:\e[0m"
  echo "  Display help for a command"
}

command_list() {
  echo -e "\e[32mButlersh\e[0m version \e[33m$B_VERSION\e[0m"
  echo
  echo -e "\e[33mUsage:\e[0m"
  echo "  command [options] [arguments]"
  echo
  echo -e "\e[33mOptions:\e[0m"
  echo -e "  \e[32m-h,\e[0m \e[32m--help\e[0m     Display help for the given command. When no command is given display help for the \e[33mlist\e[0m command"
  echo -e "  \e[32m-V,\e[0m \e[32m--version\e[0m  Display this application version"
  echo
  echo -e "\e[33mAvailable commands:\e[0m"
  echo -e "  \e[32mmysql:setup\e[0m     Set up MySQL for a fresh server"
  echo -e "  \e[32mnginx:setup\e[0m     Set up Nginx for a fresh server"
  echo -e "  \e[32mphp:setup\e[0m       Set up PHP for a fresh server"
  echo -e "  \e[32msecurity:setup\e[0m  Set up security for a fresh server"
}

command_mysql_setup() {
  run_mysql_setup "$@"
}

command_nginx_setup() {
  run_nginx_setup "$@"
}

command_php_setup() {
  run_php_setup "$@"
}

command_security_setup() {
  run_security_setup "$@"
}

# Start running

for OPTION in "$@"
do
    NAME="$(cut -d'=' -f1 <<<"$OPTION")"

    if [ "$NAME" = '--version' ]; then
      if [ "$OPTION" = '--version' ]; then
        echo -e "\e[32mButlersh\e[0m version \e[33m$B_VERSION\e[0m"
        exit 0
      fi
    fi
done

COMMAND=$1

shift

case $COMMAND in
  "help")
    if [ "$2" = "security:setup" ]; then
      B_VERSION="$B_VERSION" command_security_setup --help
      exit 0
    fi
    B_VERSION="$B_VERSION" command_help
    exit 0
    ;;

  "mysql:setup")
    B_VERSION="$B_VERSION" command_mysql_setup "$@"
    ;;

  "nginx:setup")
    B_VERSION="$B_VERSION" command_nginx_setup "$@"
    ;;

  "php:setup")
    B_VERSION="$B_VERSION" command_php_setup "$@"
    ;;

  "security:setup")
    B_VERSION="$B_VERSION" command_security_setup "$@"
    ;;

  *)
    B_VERSION="$B_VERSION" command_list
    ;;
esac
