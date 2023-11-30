#!/bin/bash

set -ex

source .env

php /var/www/html/install/index_cli.php \
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
