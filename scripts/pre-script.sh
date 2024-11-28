#!/usr/bin/env bash

# It's must be run as root.
if [ "$USER" != 'root' ]; then
    echo 'butlersh.ERROR: root privileges required. Please run this script as root.'
    exit 1
fi

# TODO: How to ensure this script running on a Ubuntu server 22.04 or 24.04?
#OS_DESC="$(lsb_release -a | grep 'Description' | awk '{print $2 " "  $3}')"
#
#case "$OS_DESC" in
#    "Ubuntu 22.04")
#        # If the OS is supported, it just continue this script.
#    ;;
#    "Ubuntu 24.04")
#        # If the OS is supported, it just continue this script.
#    ;;
#    *)
#        echo "butlersh.ERROR: Unsupported OS, currently supported Ubuntu 22.04 and 24.04"
#        exit 1
#    ;;
#esac
