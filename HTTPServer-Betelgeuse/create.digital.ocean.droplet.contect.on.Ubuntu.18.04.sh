#!/bin/bash

### Variables...
NGINXuser=

echo " Upgrading system..."
sudo apt update
sudo apt upgrade -y

sleep 2

echo " Installing google-auth..."
sudo apt install libpam-google-authenticator -y

sleep 2

echo " Configuring UFW..."
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw limit from 197.0.0.0/8 to any port 22 proto tcp comment 'SSH access for home'
sudo ufw allow from 197.0.0.0/8 to any port 80 proto tcp comment 'NGINX access for home'
sudo ufw deny from any to any

sleep 2

echo " Installing NginX and Utils..."
sudo apt install nginx apache2-utils -y

sleep 2

echo " Installing ClamAV..."
sudo apt install clamav -y
sudo service clamav-freshclam stop
sudo systemctl disable clamav-freshclam.service

sleep 2

echo " Installing Swap..."
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo cp /etc/fstab /etc/fstab.cls
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

sleep 2

echo "Run this to change Time Zone..."
echo "sudo dpkg-reconfigure tzdata"
echo ""
echo "Run this to create user for Nginx..."
echo "sudo htpasswd -B -c /etc/apache2/.htpasswd $NGINXuser"
echo ""
echo "Configure Google-auth..."
