FROM php:7-apache-buster

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
    && apt-get update \
    && apt-get install -y unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex \
    && curl -sRL https://github.com/omeka/omeka-s/releases/download/v3.0.2/omeka-s-3.0.2.zip \
       -o /var/www/omeka-s.zip \
    && unzip /var/www/omeka-s.zip -d /var/www/ \
    && rm -f /var/www/omeka-s.zip \
    && rm -rf /var/www/html \
    && mv /var/www/omeka-s /var/www/html \
    && chown -R www-data:www-data /var/www/html

COPY ./database.ini /var/www/html/config/database.ini

RUN set -ex \
    && curl -sRL https://github.com/Daniel-KM/Omeka-S-module-IiifServer/releases/download/3.6.3.3/IiifServer-3.6.3.3.zip \
       -o /var/www/IiifServer.zip \
    && unzip /var/www/IiifServer.zip -d /var/www/html/modules/ \
    && rm -f /var/www/IiifServer.zip

RUN set -ex \
    && apt-get update \
    && apt-get install -y libvips-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sRL https://github.com/Daniel-KM/Omeka-S-module-ImageServer/releases/download/3.6.6.3/ImageServer-3.6.6.3.zip \
       -o /var/www/ImageServer.zip \
    && unzip /var/www/ImageServer.zip -d /var/www/html/modules/ \
    && rm -f /var/www/ImageServer.zip

COPY ./php.ini /usr/local/etc/php/conf.d/omeka.ini

RUN set -ex \
    && apt-get update \
    && apt-get install -y imagemagick \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex \
    && curl -sRL https://github.com/Daniel-KM/Omeka-S-module-Generic/releases/download/3.3.28/Generic-3.3.28.zip \
       -o /var/www/Generic.zip \
    && unzip /var/www/Generic.zip -d /var/www/html/modules/ \
    && rm -f /var/www/Generic.zip

RUN set -ex \
    && curl -sRL https://github.com/Daniel-KM/Omeka-S-module-CleanUrl/releases/download/3.16.4.3/CleanUrl-3.16.4.3.zip \
       -o /var/www/CleanUrl.zip \
    && unzip /var/www/CleanUrl.zip -d /var/www/html/modules/ \
    && rm -f /var/www/CleanUrl.zip

RUN set -ex \
    && curl -sRL https://github.com/Daniel-KM/Omeka-S-module-UniversalViewer/releases/download/3.6.4.4/UniversalViewer-3.6.4.4.zip \
       -o /var/www/UniversalViewer.zip \
    && unzip /var/www/UniversalViewer.zip -d /var/www/html/modules/ \
    && rm -f /var/www/UniversalViewer.zip

RUN set -ex \
    && chown -R www-data:www-data /var/www/html/modules

COPY ./.htaccess /var/www/html/

RUN set -ex \
    && chown -R www-data:www-data /var/www/html/config \
    && chown -R www-data:www-data /var/www/html/.htaccess

