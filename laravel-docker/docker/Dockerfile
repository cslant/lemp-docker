FROM php:7.4-fpm

RUN apt-get update && apt-get install -y git unzip zip nano

RUN apt-get update && apt-get install -y \
    libmcrypt-dev \
    openssl \
    curl \
    vim cron \
    --no-install-recommends \
    && rm -r /var/lib/apt/lists/*

RUN docker-php-ext-install -j$(nproc) \
    bcmath \
    pdo_mysql \
    tokenizer

# Install PHP Xdebug 2.9.8
RUN pecl install -o xdebug-2.9.8

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g n \
    && n stable

WORKDIR /var/www/sources

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions gd pdo_mysql bcmath zip intl opcache mbstring exif


# RUN ["chmod", "+x", "/docker/docker-entroypoint.sh"]

# ENTRYPOINT [ "/docker/docker-entroypoint.sh" ]

CMD ["php-fpm"]

EXPOSE 80
EXPOSE 443