# Practica 01-08
En esta práctica tendremos que realizar la instalación de la aplicación web **PrestaShop** haciendo uso de los servicios de **Amazon Web Services (AWS)**.

### estructura del repositorio:
```
├── README.md
├── conf
│   └── 000-default.conf
└── scripts
    ├── .env
    ├── install_lamp.sh
    ├── install_prestashop.sh
    ├── variables_ps.sh
    ├── setup_letsencrypt_https.sh
    └── deploy_prestashop.sh
```
-   `.env`: Este archivo contiene todas las variables de configuración que se utilizarán en los scripts de **Bash**.
    
-   `install_lamp.sh`: Automatización del proceso de instalación de la pila **LAMP**.
    
-   `setup_letsencrypt_https.sh`: Automatización del proceso de solicitar un certificado **SSL/TLS de Let’s Encrypt** y configurarlo en el servidor web **Apache**.
    
-   `deploy_prestashop.sh`: Automatización del proceso de cambio sobre la configuración de **PHP**.

- `install_prestashop.sh`: Automatización del proceso de instalación de **PrestaShop** sobre el directorio  */var/www/html*.

- `variables_ps.sh`: Automatización del proceso de la configuración, son valores específicos de la instalación.
 
## .env
Configuramos las variables de todos los Scripts

    CERTIFICATE_DOMAIN=iawhttpspracticas.hopto.org
    PS_DB_NAME=ps_db
    PS_DB_USER=ps_user
    PS_DB_PASSWORD=ps_pass
    
    PS_NAME=Tienda_GSM
    PS_COUNTRY=es
    PS_FIRSTNAME=Guillermo
    PS_LASTNAME=Sanchez
    PS_PASSWORD=gsmiaw
    PS_EMAIL=gsanmoy472@g.educaand.es
    PS_DB_SERVER=127.0.0.1

## install_lamp.sh

1.  `set -ex`: Configura el modo de ejecución del script. `-e` hace que el script se detenga si algún comando devuelve un código de error, y `-x` muestra los comandos ejecutados con sus argumentos y resultados.
    
2.  `apt update`: Actualiza la lista de paquetes disponibles para su instalación.
    
3.  `apt upgrade -y`: Se utiliza para actualizar el sistema operativo y los paquetes instalados.
    
4.  `apt install apache2 -y`: Instala el servidor web **Apache**.
    
5.  `cp ../conf/000-default.conf /etc/apache2/sites-available/000-default.conf`: Copia el archivo de configuración **000-default.conf** desde el directorio *../conf/* al directorio */etc/apache2/sites-available/*.
    
6.  `apt install mysql-server -y`: Instala el servidor **MySQL**.
    
7.  `sudo apt install php libapache2-mod-php php-mysql -y`: Instala **PHP** y el módulo de **Apache** para **PHP**, así como el soporte de **MySQL** para **PHP**.
    
8.  `systemctl restart apache2`: Reinicia el servicio **Apache** para aplicar los cambios en la configuración.
    
9.  `chown -R www-data:www-data /var/www/html`: Asigna el **ownership** del directorio */var/www/html/* al usuario y grupo **www-data**.


## install_prestashop.sh
1.  `set -ex`: Configura el modo de ejecución del script. `-e` hace que el script se detenga si algún comando devuelve un código de error, y `-x` muestra los comandos ejecutados con sus argumentos y resultados.
    
2.  `apt update`: Actualiza la lista de paquetes disponibles para su instalación.
    
3.  `source .env`: Carga las variables de entorno desde el archivo `.env` al script.
    
4.  `sudo rm -rf /tmp/prestashop_8.1.2.zip`: Elimina el archivo *prestashop_8.1.2.zip* en el directorio temporal */tmp*.
    
5.  `wget https://github.com/PrestaShop/PrestaShop/releases/download/8.1.2/prestashop_8.1.2.zip -P /tmp`: Descarga el archivo *PrestaShop 8.1.2.zip* desde **GitHub** y lo guarda en */tmp*.
    
6.  `sudo rm -rf /var/www/html/*`: Elimina el contenido del directorio */var/www/html/*.
    
7.  `sudo apt install unzip -y`: Instala la utilidad **unzip** para descomprimir archivos.
    
8.  `unzip /tmp/prestashop_8.1.2.zip -d /var/www/html/`: Descomprime el archivo **PrestaShop** en el directorio */var/www/html/*.
    
9.  `sudo chown www-data:www-data /var/www/html/* -R`: Asigna el **ownership** del contenido en */var/www/html/* al usuario y grupo **www-data**.
    
10.  `mysql -u root <<< "DROP DATABASE IF EXISTS $PS_DB_NAME"`: Elimina la base de datos de **PrestaShop** si ya existe.
    
11.  `mysql -u root <<< "CREATE DATABASE $PS_DB_NAME CHARACTER SET utf8mb4"`: Crea una nueva base de datos de **PrestaShop** con el conjunto de caracteres **utf8mb4**.
    
12.  `mysql -u root <<< "DROP USER IF EXISTS $PS_DB_USER"`: Elimina el usuario de la base de datos de **PrestaShop** si ya existe.
    
13.  `mysql -u root <<< "CREATE USER IF NOT EXISTS $PS_DB_USER@'%' IDENTIFIED BY '$PS_DB_PASSWORD'"`: Crea un nuevo usuario de base de datos de **PrestaShop** con la contraseña especificada.
    
14.  `mysql -u root <<< "GRANT ALL PRIVILEGES ON $PS_DB_NAME.* TO $PS_DB_USER@'%'"`: Concede todos los privilegios al nuevo usuario sobre la base de datos de **PrestaShop**.
    
15.  `sudo systemctl restart apache2`: Reinicia el servicio **Apache** para aplicar los cambios en la configuración.

## deploy_prestashop.sh
1.  `set -ex`: Configura el modo de ejecución del script. `-e` hace que el script se detenga si algún comando devuelve un código de error, y `-x` muestra los comandos ejecutados con sus argumentos y resultados.
    
2.  `source .env`: Carga las variables de entorno desde el archivo `.env` al script.
    
3.  `sed -i 's/max_input_vars = 1000/max_input_vars = 5000/' /etc/php/8.1/apache2/php.ini`: Modifica el archivo de configuración *php.ini* para aumentar el número máximo de variables de entrada.
    
4.  `sed -i "s/memory_limit = 128/memory_limit = 256/" /etc/php/8.1/apache2/php.ini`: Modifica el límite de memoria para **PHP** en el archivo *php.ini*.
    
5.  `sed -i "s/post_max_size = 8/post_max_size = 128/" /etc/php/8.1/apache2/php.ini`: Modifica el tamaño máximo de post en el archivo *php.ini*.
    
6.  `sed -i "s/upload_max_filesize = 2/post_max_size = 128/" /etc/php/8.1/apache2/php.ini`: Modifica el tamaño máximo de carga de archivos en el archivo *php.ini*.
    
7.  `systemctl restart apache2`: Reinicia el servicio **Apache** para aplicar los cambios en la configuración de **PHP**.
    
8.  `sudo chown www-data:www-data /var/www/html -R`: Asigna el **ownership** del directorio */var/www/html/* al usuario y grupo **www-data.**
    
9.  `apt install php-bcmath -y`: Instala la extensión **bcmath** para **PHP**.
    
10.  `apt install php-intl -y`: Instala la extensión intl para **PHP**.
    
11.  `apt install memcached -y`: Instala el sistema de almacenamiento en caché **Memcached**.
    
12.  `apt install libmemcached-tools -y`: Instala las herramientas de desarrollo para **libmemcached**.
    
13.  `systemctl start memcached`: Inicia el servicio **Memcached**.
    
14.  `systemctl restart apache2`: Reinicia el servicio **Apache** para aplicar los cambios relacionados con **Memcached**.
    
15.  `sudo a2enmod headers`: Habilita el módulo de **Apache** "**headers**".
    
16.  `systemctl restart apache2`: Reinicia el servicio **Apache** para aplicar los cambios después de habilitar el módulo **headers**.

## setup_letsencrypt_https.sh
1.  `set -ex`: Configura el modo de ejecución del script. `-e` hace que el script se detenga si algún comando devuelve un código de error, y `-x` muestra los comandos ejecutados con sus argumentos y resultados.
    
2.  `source .env`: Carga las variables de entorno desde el archivo `.env` al script.
    
3.  `apt update`: Actualiza la lista de paquetes disponibles para su instalación.
    
4.  `snap install core`: Instala el paquete **core** de **Snap**.
    
5.  `snap refresh core`: Actualiza el paquete **core** de **Snap** a la última versión disponible.
    
6.  `apt remove certbot`: Desinstala el paquete **certbot**.
    
7.  `snap install --classic certbot`: Instala **certbot** como un paquete **Snap** en modo clásico.
    
8.  `ln -fs /snap/bin/certbot /usr/bin/certbot`: Crea un enlace simbólico para que el ejecutable **certbot** en */snap/bin/* esté disponible en */usr/bin/*.
    
9.  `certbot --apache -m $CERTIFICATE_EMAIL --agree-tos --no-eff-email -d $CERTIFICATE_DOMAIN --non-interactive`: Utiliza **certbot** para obtener y configurar certificados **SSL/TLS** para el dominio especificado utilizando el método de autenticación de **Apache**. Las opciones proporcionan el correo electrónico del propietario del certificado y aceptan los términos del servicio sin efectuar emails.
    
10.  `echo "Certificado SSL/TLS configurado con éxito para el dominio $CERTIFICATE_DOMAIN."`: Muestra un mensaje indicando que el certificado **SSL/TLS** se configuró con éxito para el dominio especificado.


## variables_ps.sh
1.  `set -ex`: Configura el modo de ejecución del script. `-e` hace que el script se detenga si algún comando devuelve un código de error, y `-x` muestra los comandos ejecutados con sus argumentos y resultados.
    
2.  `source .env`: Carga las variables de entorno desde el archivo `.env` al script.
    
3.  `php /var/www/html/install/index_cli.php ...`: Ejecuta un script **PHP** ubicado en */var/www/html/install/index_cli.php* con varios parámetros relacionados con la configuración de **PrestaShop**.