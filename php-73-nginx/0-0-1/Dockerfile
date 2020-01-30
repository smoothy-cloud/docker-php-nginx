#####################################
# CREATE PRODUCTION CONTAINER
#
# frontend: https://askubuntu.com/questions/972516/debian-frontend-environment-variable
# timezone: https://help.ubuntu.com/community/UbuntuTime#Using_the_Command_Line_.28unattended.29
#####################################

FROM phusion/baseimage

# make system calls non interactive
ENV DEBIAN_FRONTEND noninteractive

# update package index
RUN apt-get -qq update

# install general dependencies
RUN apt-get -qq install \
    zip \
    unzip \
    curl \
    tzdata \
    > /dev/null

#####################################
# INSTALL PHP
#
# https://thishosting.rocks/install-php-on-ubuntu/
# https://www.php.net/manual/en/install.fpm.configuration.php
#####################################

# add repository for php packages
RUN apt-add-repository ppa:ondrej/php -y

# update package index & install php packages
RUN apt-get -qq update \
 && apt-get -qq install \
    php7.3-bcmath \
    php7.3-bz2 \
    php7.3-cli \
    php7.3-common \
    php7.3-curl \
    php7.3-dev \
    php7.3-fpm \
    php7.3-gd \
    php7.3-imagick \
    php7.3-imap \
    php7.3-intl \
    php7.3-json \
    php7.3-mbstring \
    php7.3-memcached \
    php7.3-mysql \
    php7.3-opcache \
    php7.3-pgsql \
    php7.3-readline \
    php7.3-recode \
    php7.3-redis \
    php7.3-shmop \
    php7.3-soap \
    php7.3-sqlite \
    php7.3-sqlite3 \
    php7.3-xml \
    php7.3-zip \
    > /dev/null

COPY php/cli.ini /etc/php/7.3/cli/php.ini
COPY php/fpm.ini /etc/php/7.3/fpm/php.ini
COPY php/www.conf /etc/php/7.3/fpm/pool.d/www.conf

RUN mkdir -p /var/run/php \
 && chown -R www-data:www-data /var/run/php

RUN mkdir -p /app \
 && chown -R www-data:www-data /app

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
# http://nginx.org/en/linux_packages.html#Ubuntu
#####################################

# install dependencies for nginx
RUN apt-get -qq install curl gnupg2 ca-certificates lsb-release > /dev/null

# set up the apt repository for stable nginx packages
RUN echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list

# import an official nginx signing key so apt could verify the packages authenticity
RUN curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -

# update package index
RUN apt-get -qq update

# install nginx
RUN apt-get -qq install nginx > /dev/null

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

CMD sh /run.sh