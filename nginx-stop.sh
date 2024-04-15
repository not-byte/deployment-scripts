#!/bin/bash

# Stop a containerized NGINX

image="nginx"

docker container prune --force &>/dev/null
docker image prune --force &>/dev/null

docker stop "${image}" &>/dev/null
docker rm "${image}" &>/dev/null

docker volume rm "${image}" &>/dev/null