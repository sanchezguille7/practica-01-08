#!/bin/bash

set -ex

apt update

source .env

sudo rm -rf /tmp/prestashop_8.1.2.zip

wget https://github.com/PrestaShop/PrestaShop/releases/download/8.1.2/prestashop_8.1.2.zip -P /tmp

sudo rm -rf /var/www/html/*

sudo apt install unzip -y

unzip /tmp/prestashop_8.1.2.zip -d /var/www/html/

sudo chown www-data:www-data /var/www/html/* -R

mysql -u root <<< "DROP DATABASE IF EXISTS $PS_DB_NAME"
mysql -u root <<< "CREATE DATABASE $PS_DB_NAME CHARACTER SET utf8mb4"
mysql -u root <<< "DROP USER IF EXISTS $PS_DB_USER"
mysql -u root <<< "CREATE USER IF NOT EXISTS $PS_DB_USER@'%' IDENTIFIED BY '$PS_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $PS_DB_NAME.* TO $PS_DB_USER@'%'"

sudo systemctl restart apache2