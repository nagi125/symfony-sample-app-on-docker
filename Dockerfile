FROM php:7.1-fpm

ENV TZ Asia/Tokyo
ENV SYMFONY_ENV prod

# install Lib for composer
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y git zip unzip && \
    apt-get clean && \
    rm -rf /var/cache/apt

# add php,apache-module
RUN docker-php-ext-install mbstring pdo_mysql

# php.conf php-fpm.conf
COPY docker/app/conf/php/php.ini /usr/local/etc/php/php.ini
COPY docker/app/conf/php/docker.conf /usr/local/etc/php-fpm.d/docker.conf

# install Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer

COPY . /app
WORKDIR /app

COPY composer.json composer.lock /app/
RUN composer install

# change owner
RUN chown www-data:www-data -R ./

