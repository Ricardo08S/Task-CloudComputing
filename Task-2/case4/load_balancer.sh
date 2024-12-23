#!/bin/sh

docker rm -f web_server_1 web_server_2 nginx_load_balancer

docker container run \
    --name web_server_1 \
    -dit \
    -v $(pwd)/index1.html:/usr/share/nginx/html/index.html \
    nginx:alpine

docker container run \
    --name web_server_2 \
    -dit \
    -v $(pwd)/index2.html:/usr/share/nginx/html/index.html \
    nginx:alpine

docker container run \
    --name nginx_load_balancer \
    -dit \
    -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf \
    -p 8080:80 \
    --link web_server_1:web1 \
    --link web_server_2:web2 \
    nginx:alpine
