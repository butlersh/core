#!/usr/bin/env bash

B_SCRIPTS_URL="https://raw.githubusercontent.com/butlersh/core/main/scripts"

wget -qO- "$B_SCRIPTS_URL/pre-script.sh" | bash

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

# TODO: Should it be customizable via --password=<password> or prompt?
B_PASSWORD="secret"

B_USERNAME="forge"

for OPTION in "$@"
do
    NAME="$(cut -d'=' -f1 <<<"$OPTION")"
    VALUE="$(cut -d'=' -f2 <<<"$OPTION")"

    if [ "$NAME" = '--user' ]; then
        B_USERNAME="$VALUE"
    else
        echo "butlersh.ERROR: Unrecognized option $NAME."
        exit 1
    fi
done

if id "$B_USERNAME" >/dev/null 2>&1; then
    echo "butlersh.INFO: The user \"$B_USERNAME\" already exists."
else
    adduser --disabled-password --gecos "Using $B_USERNAME instead of root" "${B_USERNAME}"

    usermod --password $(echo "${B_PASSWORD}" | openssl passwd -1 -stdin) "${B_USERNAME}"
fi

usermod -aG sudo "$B_USERNAME"

rm -rf /etc/ssh/sshd_config.d/*

touch "/etc/ssh/sshd_config.d/$B_USERNAME-init.conf"

chmod 600 "/etc/ssh/sshd_config.d/$B_USERNAME-init.conf"

export SSHD_CONFIG="
PermitRootLogin no
PasswordAuthentication no
PermitEmptyPasswords no
PubkeyAuthentication yes

AllowGroups $B_USERNAME"
if ! echo "${SSHD_CONFIG}" | tee "/etc/ssh/sshd_config.d/$B_USERNAME-init.conf"; then
    echo "butlersh.ERROR: Can NOT configure SSH!" && exit 1
fi

mkdir -p "/home/$B_USERNAME/.ssh"

touch "/home/$B_USERNAME/.ssh/authorized_keys"

chmod 660 "/home/$B_USERNAME/.ssh/authorized_keys"

# Because DigitalOcean, Hetzner Cloud,... allows to SSH using root, so I just copy these keys.
# Thus, right after provision process, I can SSH using forge without adding additional SSH keys.
if [ -f /root/.ssh/authorized_keys ]; then
    cat /root/.ssh/authorized_keys > "/home/$B_USERNAME/.ssh/authorized_keys"
fi

chown -R "$B_USERNAME":"$B_USERNAME" "/home/$B_USERNAME/.ssh"

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

echo "user:$B_USERNAME" > /var/lib/butlersh/data.txt
echo "user-pass:$B_PASSWORD" > /var/lib/butlersh/data.txt
