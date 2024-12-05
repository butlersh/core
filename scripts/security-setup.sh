#!/usr/bin/env bash

help() {
  echo -e "\e[33mDescription:\e[0m"
  echo "  Set up security for a fresh server"
  echo
  echo -e "\e[33mOptions:\e[0m"
  echo -e "      \e[32m--user=USER\e[0m  The user name you want to create \e[33m[default: \"forge\"]\e[0m"
  echo -e "  \e[32m-h,\e[0m \e[32m--help\e[0m       Display help for the given command. When no command is given display help for the \e[33mlist\e[0m command"
  echo -e "  \e[32m-V,\e[0m \e[32m--version\e[0m    Display this application version"
  echo
  echo -e "\e[33mHelp:\e[0m"
  echo -e "  Running \e[32m./security-setup.sh --user=forge\e[0m will create a sudo user called \e[32mforge\e[0m."
}

version() {
  echo -e "\e[32mButlersh CLI\e[0m version \e[33m$B_VERSION\e[0m"
}

B_USER="forge"
# TODO: Should it be passed via --password=<password> option or prompt?
B_PASSWORD="secret"
# TODO: Might it allow --group=<group_name> option?
B_GROUP="$B_USER"

for OPTION in "$@"
do
    NAME="$(cut -d'=' -f1 <<<"$OPTION")"
    VALUE="$(cut -d'=' -f2 <<<"$OPTION")"

    if [ "$NAME" = '--help' ]; then
        help
        exit 0
    elif [ "$NAME" = '--version' ]; then
        version
        exit 0
    elif [ "$NAME" = '--user' ]; then
        B_USER="$VALUE"
    else
        echo "butlersh.ERROR: Unrecognized option $NAME."
        exit 1
    fi
done

B_BASE_URL="https://raw.githubusercontent.com/butlersh/core/main"

wget -qO- "$B_BASE_URL/lib/check.sh" | bash

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

if id "$B_USER" >/dev/null 2>&1; then
    echo "butlersh.INFO: The user \"$B_USER\" already exists."
else
    adduser --disabled-password --gecos "Using $B_USER instead of root" "${B_USER}"

    usermod --password $(echo "${B_PASSWORD}" | openssl passwd -1 -stdin) "${B_USER}"
fi

usermod -aG sudo "$B_USER"

rm -rf /etc/ssh/sshd_config.d/*

touch "/etc/ssh/sshd_config.d/butlersh.conf"

chmod 600 "/etc/ssh/sshd_config.d/butlersh.conf"

export SSHD_CONFIG="PermitRootLogin no
PasswordAuthentication no
PermitEmptyPasswords no
PubkeyAuthentication yes"
if ! echo "${SSHD_CONFIG}" | tee "/etc/ssh/sshd_config.d/butlersh.conf"; then
    echo "butlersh.ERROR: Can NOT configure SSH!" && exit 1
fi

mkdir -p "/home/$B_USER/.ssh"

touch "/home/$B_USER/.ssh/authorized_keys"

chmod 660 "/home/$B_USER/.ssh/authorized_keys"

# Because DigitalOcean, Hetzner Cloud,... allows to SSH using root, so I just copy these keys.
# Thus, right after provision process, I can SSH using forge without adding additional SSH keys.
if [ -f /root/.ssh/authorized_keys ]; then
    cat /root/.ssh/authorized_keys > "/home/$B_USER/.ssh/authorized_keys"
fi

chown -R "$B_USER":"$B_GROUP" "/home/$B_USER/.ssh"

systemctl restart ssh

apt-get update

apt-get install -y software-properties-common curl git unzip zip fail2ban

systemctl restart fail2ban

apt-get upgrade -y

apt-get autoremove

apt-get autoclean

mkdir -p /var/lib/butlersh

if [ ! -f /var/lib/butlersh/data.txt ]; then
  touch /var/lib/butlersh/data.txt
fi

echo "user:$B_USER" >> /var/lib/butlersh/data.txt
echo "user-pass:$B_PASSWORD" >> /var/lib/butlersh/data.txt
