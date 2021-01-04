#!/bin/bash
sudo amazon-linux-extras install nginx1 -y
sudo systemctl enable --now nginx
echo "<h1>Deployed via Terraform-${count.index}</h1>" | sudo tee /usr/share/nginx/html/index.html