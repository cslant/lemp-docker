#!/bin/bash

pecl install -o xdebug-2.9.8
docker-php-ext-enable xdebug

cd Meta
