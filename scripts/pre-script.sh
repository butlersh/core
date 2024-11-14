#!/usr/bin/env bash

# It's must be run as root.
if [ "$USER" != 'root' ]; then
    echo '[forge.ERROR] root privileges required. Please run this script as root.'
    exit 1
fi

OS_DESC="$(lsb_release -a | grep 'Description' | awk '{print $2 " "  $3}')"

# Testing on Ubuntu 22.04 and 24.04
case "$OS_DESC" in
    "Ubuntu 22.04")
        # If the OS is supported, it just continue this script.
    ;;
    "Ubuntu 24.04")
        # If the OS is supported, it just continue this script.
    ;;
    *)
        echo "[forge.ERROR] Unsupported OS, currently supported Ubuntu 22.04 and 24.04"
    ;;
esac
