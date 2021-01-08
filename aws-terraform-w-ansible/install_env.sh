#!/bin/bash
sudo dnf update -y
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
sudo dnf install python3 -y

# bash_ssh_4_CentOS
now=$(date +"%m_%d_%Y")
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config_$now.backup
sudo sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd

# set ec2-user password
echo "dkagh1." | sudo passwd --stdin ec2-user

#sudo dnf update -y
#sudo dnf install nginx -y
#sudo systemctl enable --now nginx
#sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
#sudo dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
## sudo dnf module list php
#sudo dnf module enable php:remi-7.4 -y
#sudo dnf install php php-cli php-common -y
#sudo systemctl enable --now php-fpm
#echo "<h1>Deployed via Terraform</h1>" | sudo tee /usr/share/nginx/html/index.html