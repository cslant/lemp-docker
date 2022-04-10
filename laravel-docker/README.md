# Welcome to Laravel Docker Config

This is a simple Docker Compose workflow that sets up a LEMP network of containers for local Laravel development

## Configuration requirements

To use the fpm image, you need an additional web server, such as nginx, that can proxy http-request to the fpm-port of the container. For fpm connection this container exposes port 9000.

 - Web-server: Nginx
 - DBMS (database management system): mariadb
 - PHP Framework: Laravel
 - In-memory database: Redis
 - SSL Certificate (useing Mkcert)
 
## Steps

- Add laravel source

- modify **.env**

- run 
```
docker-compose up -d
docker-compose run server composer install
docker-compose run server cp .env.example .env
docker-compose run server php artisan key:generate
```

## Check the network ID of DB

- run `docker ps` to check the Container ID of **APP_NAME-db**
- run the command `docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <container ID>`

## This is the demo of the result:
![image](https://user-images.githubusercontent.com/35853002/162612441-0084d99f-bd24-4c4c-8f50-350f642bab50.png)
