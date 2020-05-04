#####################################
# CREATE PRODUCTION CONTAINER
#
# frontend: https://askubuntu.com/questions/972516/debian-frontend-environment-variable
# timezone: https://help.ubuntu.com/community/UbuntuTime#Using_the_Command_Line_.28unattended.29
#####################################

FROM php:7.4-fpm

# make system calls non interactive
ENV DEBIAN_FRONTEND noninteractive

# install general dependencies
RUN apt-get -qq update \ 
 && apt-get -qq install zip unzip curl tzdata > /dev/null

#####################################
# INSTALL PHP EXTENSIONS
#
# https://github.com/mlocati/docker-php-extension-installer
# https://www.php.net/manual/en/install.fpm.configuration.php
#####################################

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

RUN install-php-extensions bcmath bz2 exif gd imagick imap intl memcached opcache pdo_mysql pdo_pgsql redis shmop soap zip > /dev/null

COPY php/fpm.ini /usr/local/etc/php/php.ini
COPY php/www.conf /usr/local/etc/php-fpm.d/www.conf
RUN rm -f /usr/local/etc/php-fpm.d/zz-docker.conf

RUN mkdir -p /var/run/php-fpm \
 && chown -R www-data:www-data /var/run/php-fpm

#####################################
# INSTALL COMPOSER
#####################################

# install composer
RUN curl -sS https://getcomposer.org/installer | php \
 && mv composer.phar /usr/local/bin/composer

# install prestissimo to speed up composer downloads
RUN composer global require --quiet hirak/prestissimo

#####################################
# INSTALL NGINX
#
# http://nginx.org/en/linux_packages.html#Debian
#####################################

# install dependencies for nginx
RUN apt-get -qq update \
 && apt-get -qq install curl gnupg2 ca-certificates lsb-release > /dev/null

# set up the apt repository for stable nginx packages
RUN echo "deb http://nginx.org/packages/debian `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list

# import an official nginx signing key so apt could verify the packages authenticity
RUN curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -

# install nginx
RUN apt-get -qq update \
 && apt-get -qq install nginx > /dev/null

# copy configuration
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/server.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p /var/run/nginx \
 && chown -R www-data:www-data /var/run/nginx

#####################################
# INSTALL SUPERVISOR
#
# http://supervisord.org/configuration.html
# https://github.com/richarvey/nginx-php-fpm/blob/master/conf/supervisord.conf
#####################################

# install supervisor
RUN apt-get -qq install supervisor > /dev/null

# configure supervisor
COPY supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#####################################
# CLEANUP
#####################################

RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#####################################
# START CONTAINER
#####################################

COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 80
WORKDIR /var/www/html

CMD sh /run.sh