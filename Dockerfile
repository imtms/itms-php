FROM php:7.3-fpm

ARG INSTALL_PHPREDIS=false
ARG INSTALL_MYSQLI=false
ARG INSTALL_IMAGEMAGICK=false

RUN mkdir /usr/local/php/var
RUN mkdir /usr/local/php/var/log
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-install iconv \
    && docker-php-ext-install gd
RUN docker-php-ext-install pdo_mysql
RUN chmod 755 /usr/local/bin/composer


RUN if [ ${INSTALL_PHPREDIS} = true ]; then \
    # Install Php Redis Extension
    printf "\n" | pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis \
;fi


RUN if [ ${INSTALL_MYSQLI} = true ]; then \
    docker-php-ext-install mysqli \
;fi

RUN if [ ${INSTALL_IMAGEMAGICK} = true ]; then \
    apt-get install -y libmagickwand-dev imagemagick && \
    pecl install imagick && \
    docker-php-ext-enable imagick \
;fi

COPY config/php.ini $PHP_INI_DIR/conf.d/

VOLUME ["/opt"]

CMD ["php-fpm"]
