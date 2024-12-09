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
