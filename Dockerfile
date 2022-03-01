FROM php:7-apache-bullseye

LABEL org.opencontainers.image.source https://github.com/dfukagaw28/docker-omeka-s

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
    && apt-get update \
    && apt-get install -y unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

## Omeka S
## [2021-10-16] v3.1.1
RUN set -ex \
    && curl -sRL https://github.com/omeka/omeka-s/releases/download/v3.1.1/omeka-s-3.1.1.zip \
       -o /var/www/omeka-s.zip \
    && unzip /var/www/omeka-s.zip -d /var/www/ \
    && rm -f /var/www/omeka-s.zip \
    && rm -rf /var/www/html \
    && mv /var/www/omeka-s /var/www/html \
    && chown -R www-data:www-data /var/www/html

COPY ./database.ini /var/www/html/config/database.ini

## Omeka-S-module-IiifServer
## [2022-02-14] v3.6.6.6
RUN set -ex \
    && curl -sRL https://github.com/Daniel-KM/Omeka-S-module-IiifServer/releases/download/3.6.6.6/IiifServer-3.6.6.6.zip \
       -o /var/www/IiifServer.zip \
    && unzip /var/www/IiifServer.zip -d /var/www/html/modules/ \
    && rm -f /var/www/IiifServer.zip

## Omeka-S-module-ImageServer
## [2022-02-14] v3.6.10.3
RUN set -ex \
    && apt-get update \
    && apt-get install -y libvips-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sRL https://github.com/Daniel-KM/Omeka-S-module-ImageServer/releases/download/3.6.10.3/ImageServer-3.6.10.3.zip \
       -o /var/www/ImageServer.zip \
    && unzip /var/www/ImageServer.zip -d /var/www/html/modules/ \
    && rm -f /var/www/ImageServer.zip

COPY ./php.ini /usr/local/etc/php/conf.d/omeka.ini

RUN set -ex \
    && apt-get update \
    && apt-get install -y imagemagick \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

## Omeka-S-module-Generic
## [2022-02-14] v3.3.34
RUN set -ex \
    && curl -sRL https://github.com/Daniel-KM/Omeka-S-module-Generic/releases/download/3.3.34/Generic-3.3.34.zip \
       -o /var/www/Generic.zip \
    && unzip /var/www/Generic.zip -d /var/www/html/modules/ \
    && rm -f /var/www/Generic.zip

## Omeka-S-module-CleanUrl
## [2021-11-27] v3.17.3.3
RUN set -ex \
    && curl -sRL https://github.com/Daniel-KM/Omeka-S-module-CleanUrl/releases/download/3.17.3.3/CleanUrl-3.17.3.3.zip \
       -o /var/www/CleanUrl.zip \
    && unzip /var/www/CleanUrl.zip -d /var/www/html/modules/ \
    && rm -f /var/www/CleanUrl.zip

## Omeka-S-module-UniversalViewer
## [2021-09-29] v3.6.4.5
RUN set -ex \
    && curl -sRL https://github.com/Daniel-KM/Omeka-S-module-UniversalViewer/releases/download/3.6.4.5/UniversalViewer-3.6.4.5.zip \
       -o /var/www/UniversalViewer.zip \
    && unzip /var/www/UniversalViewer.zip -d /var/www/html/modules/ \
    && rm -f /var/www/UniversalViewer.zip

## Omeka-S-module-BlocksDisposition
## [2021-01-05] v3.3.2.2
RUN set -ex \
    && curl -sRL https://github.com/Daniel-KM/Omeka-S-module-BlocksDisposition/releases/download/3.3.2.2/BlocksDisposition-3.3.2.2.zip \
       -o /var/www/BlocksDisposition.zip \
    && unzip /var/www/BlocksDisposition.zip -d /var/www/html/modules/ \
    && rm -f /var/www/BlocksDisposition.zip

## Omeka-S-module-Mirador
## [2021-10-14] v3.3.7.15
RUN set -ex \
    && curl -sRL https://github.com/Daniel-KM/Omeka-S-module-Mirador/releases/download/3.3.7.15/Mirador-3.3.7.15.zip \
       -o /var/www/Mirador.zip \
    && unzip /var/www/Mirador.zip -d /var/www/html/modules/ \
    && rm -f /var/www/Mirador.zip

RUN set -ex \
    && chown -R www-data:www-data /var/www/html/modules

COPY ./.htaccess /var/www/html/

RUN set -ex \
    && chown -R www-data:www-data /var/www/html/config \
    && chown -R www-data:www-data /var/www/html/.htaccess

