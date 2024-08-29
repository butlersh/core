Forge Like Setup 

> Inspired by Laravel Forge. https://forge.laravel.com
 
- Tested OS: 
  - Ubuntu 24.04
  - Ubuntu 22.04
- Cloud Provider:
  - Amazon EC2

## Security Setup

- Create a sudo user called `forge`.
- Prevent SSH using root user or password.
- Require SSH using public keys.
- Allow SSH with users in `forge` group only.
- Prevent brute-force attacks using fail2ban.

Imagine you've created a fresh Ubuntu server and can SSH into it as root from your computer.

```bash
ssh root@server-ip-address
```

> If you SSH as another user, you have to start a root login session after connecting to it by running "sudo su" command.

You are now in a root login session on your server.
1. Download the `security-setup.sh` script, run and then remove it.

    ```bash
    wget -O security-setup.sh https://raw.githubusercontent.com/confetticode/forge-like-setup/main/scripts/security-setup.sh
    
    bash security-setup.sh
    
    rm security-setup.sh
    ```

2. You have to set password for the `forge` user.

    ```bash
    passwd forge
    ```

3. You have to set an authorized key to `forge` user.

    ```bash
    mkdir -p /home/forge/.ssh
    
    echo "Your SSH Public Key" >> /home/forge/.ssh/authorized_keys
    
    chown -R forge:forge /home/forge/.ssh
    ```
  
Finally, back to your computer, please ensure you can SSH into your server as forge and run "sudo" commands.

```bash
# Try to SSH into your server as forge.
ssh forge@server-ip-address

# Try to run a sudo command on your server after SSH successfully.
sudo apt-get update
```
