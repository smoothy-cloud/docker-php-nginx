#!/bin/bash

#####################################
# SET TIMEZONE
#####################################

# configure Ubuntu timezone
timezone="${TIMEZONE:-Etc/UTC}";
ln -fs /usr/share/zoneinfo/$timezone /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

# configure php timezone
timezone="${TIMEZONE:-UTC}";
sed -i "s|%TIMEZONE%|$timezone|g" /usr/local/etc/php/php.ini

#####################################
# SET PHP FPM USER
#####################################

php_fpm_user="${PHP_FPM_USER:-www-data}";

sed -i "s|%PHP_FPM_USER%|$php_fpm_user|g" /usr/local/etc/php-fpm.d/www.conf

#####################################
# ENABLE/DISABLE OPCACHE
#####################################

opcache="${OPCACHE:-1}";

sed -i "s|%OPCACHE%|$opcache|g" /usr/local/etc/php-fpm.d/www.conf

#####################################
# SET APPLICATION ROOT
#####################################

application_root="${APPLICATION_ROOT:-/var/www}";

sed -i "s|%APPLICATION_ROOT%|$application_root|g" /etc/nginx/conf.d/default.conf

#####################################
# RUN ADDITIONAL ENTRYPOINTS
#####################################

for f in /entrypoints/*.sh; do
  bash "$f" -H 
done

#####################################
# START SUPERVISOR
#####################################

supervisord -c /etc/supervisor/conf.d/supervisord.conf