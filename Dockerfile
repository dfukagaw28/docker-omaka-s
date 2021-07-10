FROM php:8-apache-buster

RUN a2enmod rewrite
RUN docker-php-ext-install pdo_mysql

RUN set -ex \
    && apt-get update \
    && apt-get install -y \
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
