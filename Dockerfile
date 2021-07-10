FROM php:8-apache-buster

LABEL org.opencontainers.image.source https://github.com/dfukagaw28/docker-omaka-s

ENV DEBIAN_FRONTEND noninteractive

RUN a2enmod rewrite

RUN docker-php-ext-install pdo_mysql

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       zlib1g-dev libpng-dev \
       libfreetype6-dev \
       libjpeg62-turbo-dev \
       libwebp-dev \
       libxpm-dev \
    && docker-php-ext-configure gd \
       --with-freetype \
       --with-jpeg \
       --with-webp \
       --with-xpm \
    && docker-php-ext-install -j$(nproc) gd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex \
    && apt-get update \
    && apt-get install -y libmagickwand-dev \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex \
    && curl -sRL https://github.com/omeka/omeka-s/releases/download/v3.0.2/omeka-s-3.0.2.zip \
       -o /var/www/omeka-s.zip \
    && unzip /var/www/omeka-s.zip -d /var/www/ \
    && rm -rf /var/www/html \
    && mv /var/www/omeka-s /var/www/html \
    && chown -R www-data:www-data /var/www/html

COPY ./database.ini /var/www/html/config/database.ini
