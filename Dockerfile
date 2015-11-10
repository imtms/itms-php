FROM php:7-fpm

RUN mkdir /usr/local/php/var
RUN mkdir /usr/local/php/var/log
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install iconv mcrypt \
    && docker-php-ext-install gd
RUN docker-php-ext-install pdo_mysql
ADD composer.phar /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer

VOLUME ["/opt"]

CMD ["php-fpm"]