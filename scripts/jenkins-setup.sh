#!/usr/bin/env bash

B_BASE_URL="https://raw.githubusercontent.com/butlersh/core/jenkins-setup"

# Check if os is supported
# Check if it is root
wget -qO- "$B_BASE_URL/lib/check.sh" | bash

# Default variables
B_JENKINS_PORT=8080
B_JENKINS_DOMAIN=jenkins.butlersh.net

# Parse options
for OPTION in "$@"
do
    NAME="$(cut -d'=' -f1 <<<"$OPTION")"
    VALUE="$(cut -d'=' -f2 <<<"$OPTION")"

    if [ "$NAME" = '--port' ]; then
        B_JENKINS_PORT="$VALUE"
    elif [ "$NAME" = '--domain' ]; then
        B_JENKINS_DOMAIN="$VALUE"
    else
        echo "butlersh.ERROR: Unrecognized option $NAME"
        exit 1
    fi
done

# Install java and jenkins
sudo apt update
sudo apt install -y fontconfig openjdk-17-jre

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
 https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
 https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
 /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install -y jenkins

# TODO: Modify the default port due to --domain=<domain> option

# TODO: Check if nginx is installed and /etc/nginx/conf.d exists.

# Configure nginx reserve proxy for jenkins
wget -O jenkins.conf "$B_BASE_URL/config/site-jenkins.conf" --quiet

sed -i "s/8080/${B_JENKINS_PORT}/g" jenkins.conf;
sed -i "s/jenkins.butlersh.net/${B_JENKINS_DOMAIN}/g" jenkins.conf;

mv jenkins.conf /etc/nginx/conf.d/

systemctl reload nginx
