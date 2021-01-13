#!/bin/bash

#sudo dnf update -y
# epel-release for CentOS 8
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
# Ansible pre-require python3
sudo dnf install python3 -y

# alias
echo "alias ans='ansible'" >> ~/.bashrc
echo "alias anp='ansible-playbook'" >> ~/.bashrc
source /home/ec2-user/.bashrc

# bash_ssh_4_CentOS
now=$(date +"%m_%d_%Y")
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config_"$now".backup

# ssh timeout
sudo sed -i -e 's/#ClientAliveInterval 0/ClientAliveInterval 10m/g' /etc/ssh/sshd_config
sudo sed -i -e 's/#ClientAliveCountMax 3/ClientAliveCountMax 0/g' /etc/ssh/sshd_configz
sudo systemctl restart sshd
