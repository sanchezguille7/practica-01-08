#!/bin/bash

set -ex

source .env

apt update

snap install core
snap refresh core

apt remove certbot

snap install --classic certbot

ln -fs /snap/bin/certbot /usr/bin/certbot 

certbot --apache -m $CERTIFICATE_EMAIL --agree-tos --no-eff-email -d $CERTIFICATE_DOMAIN --non-interactive

echo "Certificado SSL/TLS configurado con éxito para el dominio $CERTIFICATE_DOMAIN."