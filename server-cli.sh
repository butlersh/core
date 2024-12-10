B_VERSION="dev-main"

# Start running

# TODO: Handle option not found error.
for OPTION in "$@"
do
    NAME="$(cut -d'=' -f1 <<<"$OPTION")"

    if [ "$NAME" = '--version' ]; then
      if [ "$OPTION" = '--version' ]; then
        display_version
        exit 0
      fi
    fi
done

COMMAND=$1

shift

# TODO: Handle command not found error.
case $COMMAND in
  "help")
    if [ "$1" = "security:setup" ]; then
      B_VERSION="$B_VERSION" help_security_setup
      exit 0
    fi
    B_VERSION="$B_VERSION" help_list_command
    exit 0
    ;;

  "mysql:setup")
    B_VERSION="$B_VERSION" run_mysql_setup "$@"
    ;;

  "nginx:setup")
    B_VERSION="$B_VERSION" run_nginx_setup "$@"
    ;;

  "php:setup")
    B_VERSION="$B_VERSION" run_php_setup "$@"
    ;;

  "security:setup")
    B_VERSION="$B_VERSION" run_security_setup "$@"
    ;;

  *)
    B_VERSION="$B_VERSION" run_list_command
    ;;
esac
