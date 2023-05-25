ARG PHP_VERSION_SELECTED=8.2

FROM php:${PHP_VERSION_SELECTED}-fpm

ARG PHP_VERSION=8.2

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    unzip \
    zip \
    nano \
    libmcrypt-dev \
    openssl \
    vim \
    cron \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    jpegoptim \
    optipng \
    pngquant \
    gifsicle \
    curl \
    gnupg2 \
    nodejs \
    unixodbc-dev \
    && rm -r /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype --with-jpeg

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions gd pdo_mysql bcmath zip intl opcache mbstring exif pcntl

RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable mysqli

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g n \
    && n stable

# Install Microsoft ODBC driver for fSQL Server
ENV ACCEPT_EULA=Y
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends msodbcsql17 \

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
COPY --from=composer/composer /usr/bin/composer /usr/local/bin/composer

WORKDIR /var/www

COPY ./docker/bash /docker/bash
RUN chmod 755 /docker/bash

RUN if test -f /docker/bash/php/php$PHP_VERSION.sh; then bash /docker/bash/php/php$PHP_VERSION.sh; fi \
    && if test -f /docker/bash/custom.sh; then bash /docker/bash/custom.sh; fi

COPY ./docker/config/docker-entrypoint.sh /docker/docker-entrypoint.sh
RUN ["chmod", "+x", "/docker/docker-entrypoint.sh"]

ENTRYPOINT [ "/docker/docker-entrypoint.sh" ]

EXPOSE 80
EXPOSE 443

CMD ["php-fpm"]
