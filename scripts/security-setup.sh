#!/usr/bin/env bash

F_SCRIPTS_URL="https://raw.githubusercontent.com/confetticode/forge-like-setup/main/scripts"

wget -qO- "$F_SCRIPTS_URL/pre-script.sh" | bash

# ./security-setup.sh --user=forge

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

# TODO: Should it be customizable via --password=<password> or prompt?
F_PASSWORD="secret"

# The default username is "forge"
F_USERNAME="forge"

for OPTION in "$@"
do
    NAME="$(cut -d'=' -f1 <<<"$OPTION")"
    VALUE="$(cut -d'=' -f2 <<<"$OPTION")"

    if [ "$NAME" = '--user' ]; then
        F_USERNAME="$VALUE"
    else
        echo "[forge.ERROR] Unrecognized option $NAME"
        exit 1
    fi
done

if id "$F_USERNAME" >/dev/null 2>&1; then
    echo "[warning] The user \"$F_USERNAME\" already exists."
else
    adduser --disabled-password --gecos "Using $F_USERNAME instead of root" "${F_USERNAME}"
fi

usermod --password $(echo "${F_PASSWORD}" | openssl passwd -1 -stdin) "${F_USERNAME}"

usermod -aG sudo "$F_USERNAME"

rm -rf /etc/ssh/sshd_config.d/*

touch "/etc/ssh/sshd_config.d/$F_USERNAME-init.conf"

chmod 600 "/etc/ssh/sshd_config.d/$F_USERNAME-init.conf"

export SSHD_CONFIG="
PermitRootLogin no
PasswordAuthentication no
PermitEmptyPasswords no
PubkeyAuthentication yes

AllowGroups $F_USERNAME"
if ! echo "${SSHD_CONFIG}" | tee "/etc/ssh/sshd_config.d/$F_USERNAME-init.conf"; then
    echo "[forge.ERROR] Can NOT configure SSH!" && exit 1
fi

mkdir -p "/home/$F_USERNAME/.ssh"

touch "/home/$F_USERNAME/.ssh/authorized_keys"

chmod 660 "/home/$F_USERNAME/.ssh/authorized_keys"

# Because DigitalOcean or Hetzner Cloud allows to SSH using root, so I just copy these keys.
# Thus, right after provision process, I can SSH using forge without adding additional SSH keys.
if [ -f /root/.ssh/authorized_keys ]; then
    cat /root/.ssh/authorized_keys > "/home/$F_USERNAME/.ssh/authorized_keys"
fi

chown -R "$F_USERNAME":"$F_USERNAME" "/home/$F_USERNAME/.ssh"

systemctl restart ssh

apt-get update

apt-get install -y software-properties-common curl git unzip zip fail2ban

systemctl restart fail2ban

apt-get upgrade -y

apt-get autoremove

apt-get autoclean
