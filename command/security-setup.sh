help_security_setup_command() {
  io_comment 'Description:'
  io_line '  Set up security for the current server'
  io_line

  io_comment 'Options:'
  io_line '  <success>    --user=USER</success>  The user name you want to create <comment>[default: "forge"]</comment>'
  io_line '  <success>-h, --help</success>       Display help for the given command. When no command is given, display help for the <success>list</success> command'
  io_line '  <success>-V, --version</success>    Display this application version'

  exit 0
}

run_security_setup_command() {
  B_USER="forge"
  B_GROUP="forge"
  # TODO: Should it be passed via --password=<password> option or prompt?
  B_PASSWORD="secret"

  for OPTION in "$@"
  do
      NAME="$(cut -d'=' -f1 <<<"$OPTION")"
      VALUE="$(cut -d'=' -f2 <<<"$OPTION")"

      if [ "$NAME" = '--user' ]; then
          B_USER="$VALUE"
          B_GROUP="$B_USER" # TODO: Might it allow --group=<group_name> option?
      else
          echo "butlersh.ERROR: Unrecognized option $NAME."
          exit 1
      fi
  done

  check_supported_os
  check_root_privileges

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

  if [ ! -f /var/lib/butlersh/security.txt ]; then
    touch /var/lib/butlersh/security.txt
  fi

  echo "username:$B_USER" >> /var/lib/butlersh/security.txt
  echo "password:$B_PASSWORD" >> /var/lib/butlersh/security.txt
}
