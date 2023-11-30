#!/bin/bash

set -ex

source .env

sed -i 's/max_input_vars = 1000/max_input_vars = 5000/' /etc/php/8.1/apache2/php.ini

sed -i "s/memory_limit = 128/memory_limit = 256/" /etc/php/8.1/apache2/php.ini

sed -i "s/post_max_size = 8/post_max_size = 128/" /etc/php/8.1/apache2/php.ini

sed -i "s/upload_max_filesize = 2/post_max_size = 128/" /etc/php/8.1/apache2/php.ini

systemctl restart apache2

sudo chown www-data:www-data /var/www/html -R

apt install php-bcmath -y

apt install php-intl -y

apt install memcached -y

apt install libmemcached-tools -y

systemctl start memcached 

systemctl restart apache2

sudo a2enmod headers

systemctl restart apache2