export B_ENV=${env:-production}
export B_VERSION=${env:-dev-main}

# Start running

# TODO: Handle option not found error.
for PARAM in "$@"
do
    NAME="$(cut -d'=' -f1 <<<"$PARAM")"

    if [ "$NAME" = '--help' ]; then
        if [ "$PARAM" = '--help' ]; then
            if [ -z "$COMMAND" ]; then
                help_list_command
            else
                case $COMMAND in
                    "mysql:setup")
                        B_VERSION="$B_VERSION" help_mysql_setup_command
                    ;;
                    "nginx:setup")
                        B_VERSION="$B_VERSION" help_nginx_setup_command
                    ;;
                    "php:setup")
                        B_VERSION="$B_VERSION" help_php_setup_command
                    ;;
                    "security:setup")
                        B_VERSION="$B_VERSION" help_security_setup_command
                    ;;
                    *)
                        B_VERSION="$B_VERSION" help_list_command
                        io_line "$COMMAND was not found"
                    ;;
                esac
            fi

        fi
    elif [ "$NAME" = '--version' ]; then
        if [ "$PARAM" = '--version' ]; then
            display_version
        fi
    else
        COMMAND=$PARAM
    fi
done

shift

# TODO: Handle command not found error.
case $COMMAND in
    "mysql:setup")
        B_VERSION="$B_VERSION" run_mysql_setup_command "$@"
    ;;

    "nginx:setup")
        B_VERSION="$B_VERSION" run_nginx_setup_command "$@"
    ;;

    "php:setup")
        B_VERSION="$B_VERSION" run_php_setup_command "$@"
    ;;

    "security:setup")
        B_VERSION="$B_VERSION" run_security_setup_command "$@"
    ;;

    *)
        B_VERSION="$B_VERSION" run_list_command
    ;;
esac
