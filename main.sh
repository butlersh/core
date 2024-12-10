export B_ENV=${env:-production}
export B_VERSION=${env:-dev-main}

B_COMMAND=''
B_OPTIONS=()
B_OPTIONS_STR=''
B_ARGUMENTS=()
B_ARGUMENTS_STR=''
B_NEEDS_HELP="no"

for PARAM in "$@"
do
    NAME="$(cut -d'=' -f1 <<<"$PARAM")"

    if [ "$PARAM" = 'help' ]; then
        B_NEEDS_HELP='yes'
    elif [ "$NAME" = '--help' ]; then
        if [ "$PARAM" = '--help' ]; then
            B_NEEDS_HELP='yes'
        else
            io_print_error "The --help option does not accept a value"
            exit 1
        fi
    elif [ "$NAME" = '--version' ]; then
        if [ "$PARAM" = '--version' ]; then
            display_version
        else
            io_print_error "The --version option does not accept a value"
            exit 1
        fi
    elif [[ "$PARAM" == -* ]]; then
        B_OPTIONS+=("$PARAM")
        B_OPTIONS_STR="$B_OPTIONS_STR $PARAM"
    elif [ -z "$B_COMMAND" ]; then
        B_COMMAND="$PARAM"
    else
        B_ARGUMENTS+=("$PARAM")
        B_ARGUMENTS_STR="$B_ARGUMENTS_STR $PARAM"
    fi
done

if [ $B_NEEDS_HELP = 'yes' ] && [ -z "$B_COMMAND" ]; then
    help_list_command
fi

if [ $B_NEEDS_HELP = 'yes' ] && [ "$B_COMMAND" != '' ]; then
    case $B_COMMAND in
        "list")
            help_list_command
        ;;
        "mysql:setup")
            help_mysql_setup_command
        ;;
        "nginx:setup")
            help_nginx_setup_command
        ;;
        "php:setup")
            help_php_setup_command
        ;;
        "security:setup")
            help_security_setup_command
        ;;
        *)
            io_print_error "The <comment>$RUNNING_COMMAND</comment> command was not found."
            exit 1
        ;;
    esac
fi

if [ -z "$B_COMMAND" ]; then
    run_list_command
    exit 0
fi

run() {
    RUNNING_COMMAND="$1"

    shift

    case $RUNNING_COMMAND in
        "list")
            run_list_command "$@"
        ;;

        "mysql:setup")
            run_mysql_setup_command "$@"
        ;;

        "nginx:setup")
            run_nginx_setup_command "$@"
        ;;

        "php:setup")
            run_php_setup_command "$@"
        ;;

        "security:setup")
            run_security_setup_command "$@"
        ;;

        *)
            io_print_error "The <comment>$RUNNING_COMMAND</comment> command was not found."
            exit 1
        ;;
    esac
}

run "$B_COMMAND" $B_ARGUMENTS_STR $B_OPTIONS_STR
