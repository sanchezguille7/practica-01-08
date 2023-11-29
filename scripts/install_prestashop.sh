#!/bin/bash

set -ex

cd /tmp

# Obtenemos PrestaShop desde su repositorio de GitHub.

wget https://github.com/PrestaShop/PrestaShop/releases/download/8.1.2/prestashop_8.1.2.zip

# Instalamos Unzip para descomprimir.

sudo apt install unzip -y

unzip /tmp/prestashop_8.1.2.zip

unzip /tmp/prestashop.zip -d /var/www/html/

# Borramos todos los archivos temporales del zip.

rm -f /tmp/prestashop*

# Nos situamos en el directorio de instalacion de prestashop.

cd /var/www/html/install