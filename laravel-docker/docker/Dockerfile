FROM php:7.4-fpm

RUN apt-get update && apt-get install -y git unzip zip nano

WORKDIR /var/www/html

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

RUN docker-php-ext-install -j$(nproc) \
    bcmath \
    pdo_mysql \
    tokenizer


COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions gd pdo_mysql bcmath zip intl opcache mbstring exif pcntl

# Install PHP Xdebug 2.9.8
RUN pecl install -o xdebug-2.9.8

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g n \
    && n stable

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN ["chmod", "+x", "/docker/docker-entroypoint.sh"]

ENTRYPOINT [ "/docker/docker-entroypoint.sh" ]

EXPOSE 80
EXPOSE 443

CMD ["php-fpm"]