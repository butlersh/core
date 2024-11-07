#!/usr/bin/env bash

COMMAND=$1

case $COMMAND in
  "help")
    echo "Forge CLI dev-main"
    ;;

  "site:create")
    echo "Create a new site"
    ;;

  "site:delete")
    echo "Delete a site"
    ;;

  *)
    echo "[error] Unrecognized command \"$COMMAND\". Please run \"forge help\" for more details"
    ;;
esac
