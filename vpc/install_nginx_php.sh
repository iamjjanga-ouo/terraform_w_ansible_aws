#!/bin/bash
sudo dnf install nginx -y
sudo systemctl enable --now nginx
echo "<h1>Deployed via Terraform</h1>" | sudo tee /usr/share/nginx/html/index.html