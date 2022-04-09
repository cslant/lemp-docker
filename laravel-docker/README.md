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

## Redis

```
docker exec -it <container_name> bash
```

And then run:

```

```