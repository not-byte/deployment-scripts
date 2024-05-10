#!/bin/bash

docker network prune --force &>/dev/null
docker container prune --force &>/dev/null
docker image prune --force &>/dev/null

# Stop a containerized NGINX Webserver

network="web"
name="nginx"

docker network rm "${network}" &>/dev/null

docker stop "${name}" &>/dev/null
docker rm "${name}" &>/dev/null