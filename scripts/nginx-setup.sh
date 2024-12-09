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
export NEEDRESTART_MODE=a

B_CONFIG_URL="https://raw.githubusercontent.com/butlersh/core/main/config"
B_USER="forge"

for OPTION in "$@"
do
    NAME="$(cut -d'=' -f1 <<<"$OPTION")"
    VALUE="$(cut -d'=' -f2 <<<"$OPTION")"

    if [ "$NAME" = '--user' ]; then
        B_USER="$VALUE"
    else
        echo "butlersh.ERROR: Unrecognized option $NAME"
        exit 1
    fi
done

# Install nginx with certbot to use free SSL via Letsencrypt.
apt-get install -y nginx certbot python3-certbot-nginx

if [ -d /etc/nginx ]; then
  rm -rf /etc/nginx.old

  mv /etc/nginx /etc/nginx.old
fi

git clone https://github.com/h5bp/server-configs-nginx.git /etc/nginx

mkdir -p /etc/nginx/extra

wget -O fastcgi.conf "$B_CONFIG_URL/fastcgi.conf" --quiet
wget -O fastcgi-php.conf "$B_CONFIG_URL/fastcgi-php.conf" --quiet

mv fastcgi.conf /etc/nginx/extra/fastcgi.conf
mv fastcgi-php.conf /etc/nginx/extra/fastcgi-php.conf

sed -i "s/www-data/${B_USER}/g" /etc/nginx/nginx.conf;

systemctl restart nginx
