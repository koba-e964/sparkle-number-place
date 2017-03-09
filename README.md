# sparkle-number-place

## Dependencies
You need `docker` to run this server.

## How to run
```
$ docker-compose build
Building sudoku-server
Step 1/10 : FROM nginx:1.11.10
 ---> 6b914bbcb89e
 (omitted)
Step 10/10 : COPY files/nginx.conf /etc/nginx/nginx.conf
 ---> Using cache
 ---> 3168272d9a40
Successfully built 3168272d9a40
$ docker-compose up -d
Creating sparklenumberplace_sudoku-server_1
$ docker ps
CONTAINER ID        IMAGE                              COMMAND                  CREATED              STATUS              PORTS                            NAMES
9bedf67e62bd        sparklenumberplace_sudoku-server   "nginx -g 'daemon ..."   About a minute ago   Up About a minute   443/tcp, 0.0.0.0:32768->80/tcp   sparklenumberplace_sudoku-server_1
$ docker ps --format "{{.Ports}}"
443/tcp, 0.0.0.0:32768->80/tcp
```
You can view the page by accessing `0.0.0.0:32768`.