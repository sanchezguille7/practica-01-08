#!/bin/bash

set -ex

source .env

sed -i 's/max_input_vars = 1000/max_input_vars = 5000/' /etc/php/8.1/apache2/php.ini

sed -i "s/memory_limit = 128/memory_limit = 256/" /etc/php/8.1/apache2/php.ini

sed -i "s/post_max_size = 8/post_max_size = 128/" /etc/php/8.1/apache2/php.ini

sed -i "s/upload_max_filesize = 2/post_max_size = 128/" /etc/php/8.1/apache2/php.ini

systemctl restart apache2

rm -rf /tmp/php-ps-info

cd /tmp

git clone https://github.com/PrestaShop/php-ps-info.git

cd php-ps-info/

mv phppsinfo.php /var/www/html/

sudo chown www-data:www-data /var/www/html -R

# Instalación de BCMath Arbitrary Precision Mathematics.

apt install php-bcmath -y

# Instalación de Internationalization Functions.

apt install php-intl -y

# Instalación de Memcached

apt install memcached -y

apt install libmemcached-tools -y

systemctl start memcached 

systemctl restart apache2

sudo a2enmod headers

systemctl restart apache2

#Paso 1. Creación de la base de datos de los usuarios de bd.

mysql -u root <<< "DROP DATABASE IF EXISTS $PS_DB_NAME;"
mysql -u root <<< "CREATE DATABASE $PS_DB_NAME CHARACTER SET utf8mb4;"

mysql -u root <<< "DROP USER IF EXISTS $PS_DB_USER;"
mysql -u root <<< "CREATE USER IF NOT EXISTS $PS_DB_USER@'%' IDENTIFIED BY '$PS_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $PS_DB_NAME.* TO $PS_DB_USER@'%';"
mysql -u root <<< "FLUSH PRIVILEGES;" 

# Directorio temporal.

cd /tmp

# Variables de PHP que se ejecutarán en la instalación sustituyendo la interfaz gráfica.

cd /var/www/html/install

php index_cli.php \
    --db_server=$PS_DB_SERVER \
    --db_user=$PS_DB_USER \
    --db_name=$PS_DB_NAME \
    --db_password=$PS_DB_PASSWORD \
    --language=$PS_COUNTRY \
    --name=$PS_NAME \
    --country=$PS_COUNTRY \
    --firstname=$PS_FIRSTNAME \
    --lastname=$PS_LASTNAME \
    --admin_password=$PS_PASSWORD \
    --email=$PS_EMAIL \
    --domain=$CERTIFICATE_DOMAIN \
    --ssl=1
