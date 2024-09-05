# Forge-Like Setup 

> Inspired by Laravel Forge. https://forge.laravel.com
 
- Tested OS: 
  - Ubuntu 24.04
  - Ubuntu 22.04
- Cloud Provider:
  - Amazon EC2

## Security Setup

The main purpose is creating a sudo user called `forge` to manage it's server.

- Create a sudo user called `forge`.
- Prevent SSH using root user or password.
- Require SSH using public keys.
- Allow SSH with users in `forge` group only.
- Additionally, prevent brute-force attacks using fail2ban.

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

2. You should set password for the `forge` user.

    ```bash
    passwd forge
    ```

3. You have to set an authorized key for the `forge` user.

    ```bash
    echo "Your SSH Public Key" >> /home/forge/.ssh/authorized_keys
    ```
  
Finally, back to your computer, please ensure you can SSH into your server as forge and run "sudo" commands.

```bash
# Try to SSH into your server as forge.
ssh forge@server-ip-address

# Try to run a sudo command on your server after SSH successfully.
sudo apt-get update
```

## Firewall Setup

I recommend you using firewall powered by your cloud provider. E.g. AWS Security Groups, Hetzner Cloud Firewall, ... Otherwise, you can use ufw (built on top of iptables).

```bash
# Allow SSH
sudo ufw allow 22
# Allow HTTP
sudo ufw allow 80
# Allow HTTPs
sudo ufw allow 443
# Turn on UFW
echo "y" | sudo ufw enable
```

## Nginx Setup

On your server, run these commands as root.
```bash
wget -O security-setup.sh https://raw.githubusercontent.com/confetticode/forge-like-setup/main/scripts/nginx-setup.sh
    
bash nginx-setup.sh

rm nginx-setup.sh
```

## PHP Setup

On your server, run these commands as root.
```bash
wget -O security-setup.sh https://raw.githubusercontent.com/confetticode/forge-like-setup/main/scripts/php-setup.sh
    
bash php-setup.sh 8.3 # Replace 8.3 with your expected PHP version.

rm php-setup.sh
```

## MySQL Setup

On your server, run these commands as root.
