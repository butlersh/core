#!/usr/bin/env bash

if [ "$USER" != 'root' ]; then
    echo 'root privileges required. Please run this script as root.'
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

# TODO: Should be customizable.
C_USERNAME="forge"
C_PASSWORD="secret"

if id "forge" >/dev/null 2>&1; then
    echo "The user \"forge\" already exists."
else
    adduser --disabled-password --gecos "The root alternative" "${C_USERNAME}"
fi

usermod --password $(echo "${C_PASSWORD}" | openssl passwd -1 -stdin) "${SC_USER}"

usermod -aG sudo forge

rm -rf /etc/ssh/sshd_config.d/*

touch /etc/ssh/sshd_config.d/forge-init.conf

chmod 600 /etc/ssh/sshd_config.d/forge-init.conf

export SSHD_CONFIG="
PermitRootLogin no
PasswordAuthentication no
PermitEmptyPasswords no
PubkeyAuthentication yes

AllowGroups forge"
if ! echo "${SSHD_CONFIG}" | tee /etc/ssh/sshd_config.d/forge-init.conf; then
    echo "Can NOT configure SSH!" && exit 1
fi

mkdir -p /home/forge/.ssh

touch /home/forge/.ssh/authorized_keys

chown -R forge:forge /home/forge/.ssh

systemctl restart ssh

sudo apt-get update

sudo apt-get install -y software-properties-common curl git unzip zip fail2ban

systemctl restart fail2ban
