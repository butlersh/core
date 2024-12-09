#!/usr/bin/env bash
check_root_privileges() {
    if [ "$USER" != 'root' ]; then
        echo 'butlersh.ERROR: Please run this script as root.'
        exit 1
    fi
}

check_supported_os() {
  # TODO: If lsb_release does not exit, use /etc/os-release instead.
  OS_DISTRIB_NAME=${OS_DISTRIB_NAME:-$(lsb_release -is)}
  OS_RELEASE_NAME=${OS_RELEASE_NAME:-$(lsb_release -cs)}

  case "${OS_DISTRIB_NAME}" in
    "Ubuntu" | "ubuntu")
      DISTRIB_NAME="ubuntu"
      case "${OS_RELEASE_NAME}" in
        "noble" | "jammy" | "focal")
          RELEASE_NAME="${OS_RELEASE_NAME}"
        ;;
        *)
          RELEASE_NAME="unsupported"
        ;;
      esac
    ;;
    *)
      DISTRIB_NAME="unsupported"
    ;;
  esac

  if [[ "${DISTRIB_NAME}" == "unsupported" || "${RELEASE_NAME}" == "unsupported" ]]; then
    echo "This Linux distribution isn't supported yet."
    echo "If you'd like it to be, let us know!"
    echo "👉🏻 https://github.com/butlersh/butlersh/issues"
    exit 1
  fi
}
export B_VERSION=${env:-dev-main}

display_version() {
  echo -e "\e[32mButlersh CLI\e[0m version \e[33m$B_VERSION\e[0m"
}
check_supported_os
check_root_privileges

export DEBIAN_FRONTEND=noninteractive

B_MYSQL_VERSION='8.0'

# TODO: Should be customizable.
B_MYSQL_PASSWORD="secret"

for OPTION in "$@"
do
    NAME="$(cut -d'=' -f1 <<<"$OPTION")"
    VALUE="$(cut -d'=' -f2 <<<"$OPTION")"

    if [ "$NAME" = '--version' ]; then
        B_MYSQL_VERSION="$VALUE"
    else
        echo "butlersh.ERROR: Unrecognized argument/option $NAME."
        exit 1
    fi
done

mysql80 () {
    echo "butlersh.INFO: Start installing MySQL $B_MYSQL_VERSION"

    debconf-set-selections <<< "mysql-server mysql-server/root_password password ${B_MYSQL_PASSWORD}"
    debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${B_MYSQL_PASSWORD}"

    apt-get -y install mysql-server

    echo "butlersh.INFO: Finished installing MySQL $B_MYSQL_VERSION"

    mysql --version
}

case "$B_MYSQL_VERSION" in
    "8.0")
        mysql80
    ;;
    *)
        echo "butlersh.ERROR: Unsupported MySQL version $B_MYSQL_VERSION"
        exit 1
    ;;
esac
