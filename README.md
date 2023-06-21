# Welcome to Docker Config for LEMP Network

:whale: This is a simple Docker Compose workflow that sets up a LEMP network with PHP, Nginx, MariaDB, etc.

This configuration can be used for any PHP project (Laravel, Yii, CodeIgniter, Pure PHP, etc.) :tada:

[![Docker](https://github.com/lbiltech/lemp-docker/actions/workflows/docker-publish.yml/badge.svg)](https://hub.docker.com/r/lbiltech/lemp)

## Table of Contents

 - [Configuration requirements](#configuration-requirements)
 - [Add your custom bash script to run docker](#add-your-custom-bash-script-to-run-docker)
 - [Installation and Setup](#installation-and-setup)
 - [Check the network ID and connect Database](#check-the-network-id-and-connect-database)


> Other docker configs: [LAMP Stack (Apache, PHP, MariaDB, Redis)](https://github.com/tanhongit/lamp-docker.git) :whale:

## Configuration requirements

To use the fpm image, you need an additional web server, such as Nginx, that can proxy HTTP-request to the fpm-port of the container. For fpm connection, this container exposes port 9000.

- **Multi-site integration**
- **PHP optional version with custom in .env file** (example: 7.4, 8.0, 8.1, 8.2, etc.)
- Web-server: **Nginx**
- DBMS (database management system): **Mariadb**
- In-memory database: **Redis**
- SSL Certificate (using **mkcert**)

## Add your custom bash script to run the docker

> **Because maybe my configuration is not enough for the configuration required by your project or purpose, you need to add more configuration to the docker.**

With nature of allowing you to customize the PHP version according to your. We should also allow custom bash scripts to run when starting the docker.

So, you can add your custom bash script to run docker in the file **_docker/bash/custom.sh_** with the following steps:

### 1. Create a file **_docker/bash/custom.sh_**:

Run:

```bash
cd docker/bash
cp custom.sh.example custom.sh
```

### 2. Add your custom bash script to run the docker

Then, you can add your custom bash script to run docker in the file **_docker/bash/custom.sh_**.

For example, you want to install **_ngrok_** extension for your docker container:

```bash
#!/bin/bash

# Install ngrok
snap install ngrok

# Install ngrok for php
docker-php-ext-install ngrok

# You can install other extensions here
# docker-php-ext-install <extension_name>

# etc.
npm install -g localtunnel
```

And now, just follow the steps below and run the docker.

## Installation and Setup

> **Warning**: If you don't want to use SSL, you can skip steps 1 and 2 and edit conf files in _**docker/config/conf.d/*.conf**_ to remove the SSL configuration.

Please remove the 443 port in _**docker/config/conf.d/*.conf**_ file and use 80 port for HTTP:

```nginx
server {
    listen 80;
    server_name laravel-demo-site.com;
    root /var/www/laravel-demo/public;
    index index.php index.html index.htm;

    access_log /var/log/nginx/laravel-demo.access.log;
    error_log /var/log/nginx/laravel-demo.error.log;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_pass php:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
```

If you want to use SSL, please ignore the above warning and follow all the steps below.

### 1. Install SSL certificate

Using mkcert to create ssl certificate

#### For Ubuntu

```shell
sudo apt install libnss3-tools

sudo wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64 && \
sudo mv mkcert-v1.4.3-linux-amd64 mkcert && \
sudo chmod +x mkcert && \
sudo cp mkcert /usr/local/bin/
```

#### For Mac or Windows

Please check and install mkcert at: https://github.com/FiloSottile/mkcert

Now that the mkcert utility is installed, run the command below to generate and install your local CA:

```shell
mkcert -install
```

### 2. Create an SSL certificate for this project

Run:

```shell
cd docker/server/certs
mkcert demo-site.local
mkcert laravel-demo-site.com
```

### 3. Run to start the docker

```shell
docker-compose up -d
```

### 4. Modify **.env** on the Laravel source

```dotenv
PHP_VERSION_SELECTED=8.2 # Choose the PHP version for your project

APP_NAME=lemp-stack # name of your docker project
APP_PORT=91 # port for docker server (apache)
SSL_PORT=448 # port for docker server (apache) with SSL
DB_PORT=13393 # port for the database (MariaDB)

MYSQL_ROOT_PASS=root
MYSQL_USER=root
MYSQL_PASS=root
MYSQL_DB=default-db # name of your database

PHPMYADMIN_PORT=9018 # port for phpmyadmin (database admin)
PHPMYADMIN_UPLOAD_LIMIT=1024M # set upload limit for phpmyadmin
IP_DB_SERVER=127.0.0.1

REDIS_PORT=16379 # port for Redis (in-memory database)
```

## Check the network ID and connect the Database

### 1. Check CONTAINER ID
- Run `docker ps` to check the Container ID of **APP_NAME-db**
- Run the command `docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <container ID>`

```shell
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <container_ID>
```

![image](https://user-images.githubusercontent.com/35853002/232272286-4dd7cc26-1257-4b1e-9605-7d6ecfd69a37.png)


### 2. Connect to Database

Use the IP address to connect to the database using the database management system (DBMS) of your choice. For example, using MySQL Workbench:

![image](https://user-images.githubusercontent.com/35853002/232210044-7dd5aafa-352f-45d8-ba99-82cb792b1066.png)

You can also connect to the database using the DB_PORT in the .env file

For example, using MySQL Workbench: DB_PORT=13398

![image](https://user-images.githubusercontent.com/35853002/232210171-af56d440-c9f0-4477-a1a7-338b86995cd7.png)

## This is the demo of the result:
![image](https://user-images.githubusercontent.com/35853002/183320614-fa670785-9aa7-411a-a1ff-15e349cee58d.png)

## Add database for the second project (When using multiple sites)

What was instructed above can only be applied and created a database for **default-db**

For __laravel-demo-site.com__ to work, you need to create a new database for it.

Please add a new database for laravel-demo-site.com with the __phpmyadmin__ tool or any other tool you like. And then, please update __DB_HOST__ on __.env__ file to the new database of __laravel-demo__ source.

Example: This configuration in **laravel-demo** source

```dotenv
DB_CONNECTION=mysql
DB_HOST=172.21.0.3 # IP address of APP_NAME-db
DB_PORT=3306
DB_DATABASE=laravel_demo # name of the database
DB_USERNAME=root
DB_PASSWORD=root
```
