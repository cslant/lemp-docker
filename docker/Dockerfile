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

RUN case "$PHP_VERSION" in \
  7.1) \
    pecl install -o xdebug-2.6.1 \
    ;; \
  7.2) \
    pecl install -o xdebug-2.9.8 \
    ;; \
  7.3) \
    pecl install -o xdebug-2.9.8 \
    ;; \
  7.4) \
    pecl install -o xdebug-2.9.8 \
    ;; \
  8.0) \
    pecl install -o xdebug-3.0.4 \
    ;; \
  8.1) \
    pecl install -o xdebug-3.1.0 \
    ;; \
  8.2) \
    pecl install -o xdebug-3.2.0 \
    ;; \
  *) \
    echo "Unsupported PHP version: $PHP_VERSION" \
    exit 1 \
    ;; \
esac

RUN docker-php-ext-enable xdebug

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

COPY ./docker/config/docker-entrypoint.sh /docker/docker-entrypoint.sh
RUN ["chmod", "+x", "/docker/docker-entrypoint.sh"]

ENTRYPOINT [ "/docker/docker-entrypoint.sh" ]

EXPOSE 80
EXPOSE 443

CMD ["php-fpm"]