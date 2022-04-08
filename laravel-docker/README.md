# PYL Docker



## Steps

- copy PYL source code to folder **codebase**
- modify **.env**
- run `docker-compose up -d`

## Check the network ID of DB

- run `docker ps` to check the Container ID of **APP_NAME-db**
- run the command `docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <container ID>`


