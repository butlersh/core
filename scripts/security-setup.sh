#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

if id "forge" >/dev/null 2>&1; then
    echo "The user \"forge\" already exists"
else
    adduser --disabled-password --gecos "The root alternative" forge
fi

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
    echo "Can't configure SSH!" && exit 1
fi

systemctl restart sshd

sudo apt-get update

sudo apt-get install -y fail2ban

systemctl restart fail2ban
