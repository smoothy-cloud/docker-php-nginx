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
sed -i "s|%TIMEZONE%|$timezone|g" /etc/php/7.3/cli/php.ini
sed -i "s|%TIMEZONE%|$timezone|g" /etc/php/7.3/fpm/php.ini

#####################################
# SET APPLICATION ROOT
#####################################

# define application root
application_root="${APPLICATION_ROOT:-/app}";

# configure nginx
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