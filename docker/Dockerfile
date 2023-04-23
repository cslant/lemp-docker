ARG PHP_VERSION_SELECTED=8.1

FROM php:${PHP_VERSION_SELECTED}-fpm

ARG PHP_VERSION

RUN apt-get update && apt-get install -y git unzip zip nano

WORKDIR /var/www

RUN apt-get update && apt-get install -y \
    libmcrypt-dev \
    openssl \
    vim cron \
    --no-install-recommends \
    && rm -r /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    jpegoptim optipng pngquant gifsicle \
    curl

RUN docker-php-ext-configure gd --with-freetype --with-jpeg

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions gd pdo_mysql bcmath zip intl opcache mbstring exif pcntl

RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable mysqli

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g n \
    && n stable

ENV ACCEPT_EULA=Y
RUN apt-get update && apt-get install -y gnupg2
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get -y --no-install-recommends install msodbcsql17 unixodbc-dev

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
COPY --from=composer/composer /usr/bin/composer /usr/local/bin/composer

COPY ./docker/bash /docker/bash
RUN chmod 755 /docker/bash

RUN case "$PHP_VERSION" in \
  7.1) \
    bash /docker/bash/php7.1.sh \
    ;; \
  7.2) \
    bash /docker/bash/php7.2.sh \
    ;; \
  7.3) \
    bash /docker/bash/php7.3.sh \
    ;; \
  7.4) \
    bash /docker/bash/php7.4.sh \
    ;; \
  8.0) \
    bash /docker/bash/php8.0.sh \
    ;; \
  8.1) \
    bash /docker/bash/php8.1.sh \
    ;; \
  8.2) \
    bash /docker/bash/php8.2.sh \
    ;; \
  *) \
    echo "Unsupported PHP version: $PHP_VERSION" \
    exit 1 \
    ;; \
esac

COPY ./docker/config/docker-entrypoint.sh /docker/docker-entrypoint.sh
RUN ["chmod", "+x", "/docker/docker-entrypoint.sh"]

ENTRYPOINT [ "/docker/docker-entrypoint.sh" ]

EXPOSE 80
EXPOSE 443

CMD ["php-fpm"]