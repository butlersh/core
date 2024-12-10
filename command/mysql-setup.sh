help_mysql_setup_command() {
  io_comment 'Description:'
  io_line '  Set up MySQL for the current server'
  io_line

  io_comment 'Usage:'
  io_line '  mysql:setup [options] [--] <version>'
  io_line

  io_comment 'Arguments:'
  io_line '  <success>version</success>        The expected MySQL version <comment>[e.g. "8.0"]</comment>'
  io_line

  io_comment 'Options:'
  io_line '  <success>-h, --help</success>     Display help for the given command. When no command is given, display help for the <success>list</success> command'
  io_line '  <success>-V, --version</success>  Display this application version'

  exit 0
}

mysql80 () {
  echo "butlersh.INFO: Start installing MySQL $B_MYSQL_VERSION"

  debconf-set-selections <<< "mysql-server mysql-server/root_password password ${B_MYSQL_PASSWORD}"
  debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${B_MYSQL_PASSWORD}"

  apt-get -y install mysql-server

  echo "butlersh.INFO: Finished installing MySQL $B_MYSQL_VERSION"
}

run_mysql_setup_command() {
  B_MYSQL_VERSION='8.0'

  # TODO: Should be customizable.
  B_MYSQL_PASSWORD="secret"

  B_MYSQL_VERSION=$1

  check_supported_os
  check_root_privileges

  export DEBIAN_FRONTEND=noninteractive

  case "$B_MYSQL_VERSION" in
      "8.0")
          mysql80
      ;;
      *)
          echo "butlersh.ERROR: Unsupported MySQL version $B_MYSQL_VERSION"
          exit 1
      ;;
  esac
}
