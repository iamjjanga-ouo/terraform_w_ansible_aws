#!/bin/bash
sudo dnf update -y
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
sudo dnf install python3 -y
sudo dnf install ansible -y

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