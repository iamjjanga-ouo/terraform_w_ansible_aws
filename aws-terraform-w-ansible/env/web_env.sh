#!/bin/bash

# set ec2-user password
echo "dkagh1." | sudo passwd --stdin ec2-user

# bash_ssh_4_CentOS
now=$(date +"%m_%d_%Y")
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config_"$now".backup
sudo sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

# ssh timeout
sudo sed -i -e 's/#ClientAliveInterval 0/ClientAliveInterval 10m/g' /etc/ssh/sshd_config
sudo sed -i -e 's/#ClientAliveCountMax 3/ClientAliveCountMax 0/g' /etc/ssh/sshd_config
sudo systemctl restart sshd


