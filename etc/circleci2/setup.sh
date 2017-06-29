#!/bin/sh

set -e -x

echo "127.0.0.1 www.3kworkshop.loc" >> /etc/hosts
echo "127.0.0.1 test.3kworkshop.loc" >> /etc/hosts

#Setup Nginx (with ssl)
mkdir /etc/nginx/ssl/
cp etc/circleci2/ssl/server.crt /etc/nginx/ssl/server.crt
cp etc/circleci2/ssl/server.key /etc/nginx/ssl/server.key
cp etc/circleci2/symfony-test.conf /etc/nginx/sites-enabled/symfony-test.conf
sed -i.bak "s#TEST_DOMAIN_NAME#www.3kworkshop.loc#g" /etc/nginx/sites-enabled/symfony-test.conf
sed -i.bak "s#WEBROOT_PATH#/var/www/web/#g" /etc/nginx/sites-enabled/symfony-test.conf
rm /etc/nginx/sites-enabled/symfony-test.conf.bak


#Copy over needed files
cp etc/circleci2/app/config/parameters.yml app/config/parameters.yml
cp etc/circleci2/web/app_test.php web/app_test.php

#Modify current config to use CirclCI specific infrastructure
sed -i 's/selenium:4444/localhost:4444/' behat.yml
sed -i 's/mysql_test/127.0.0.1/' app/config/config_test.yml


#Setup cache & logs folders with proper permissions
mkdir -p /dev/shm/3kworkshop/cache /dev/shm/3kworkshop/logs
setfacl -R -m u:www-data:rwx -m u:`whoami`:rwx  /dev/shm/3kworkshop/cache /dev/shm/3kworkshop/logs
setfacl -dR -m u:www-data:rwx -m u:`whoami`:rwx /dev/shm/3kworkshop/cache /dev/shm/3kworkshop/logs
chmod 777 -R /dev/shm/3kworkshop/cache /dev/shm/3kworkshop/logs

