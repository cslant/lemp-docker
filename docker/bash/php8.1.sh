#!/bin/bash

pecl install sqlsrv
pecl install pdo_sqlsrv
docker-php-ext-enable sqlsrv pdo_sqlsrv

pecl install -o xdebug-3.1.0
docker-php-ext-enable xdebug