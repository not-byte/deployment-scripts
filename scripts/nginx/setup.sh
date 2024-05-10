#!/bin/bash

docker container prune --force &>/dev/null
docker image prune --force &>/dev/null

# Run a containerized NGINX Webserver

network="bridge"

name="nginx"
image="${name}:latest"
ports=(80 443)

docker pull "$image" &>/dev/null

docker stop "${name}" &>/dev/null
docker rm "${name}" &>/dev/null

docker run \
  --name "${name}" \
  --detach \
  --restart always \
  --network "${network}" \
  --ip 172.168.0.2 \
  --volume /etc/ssl:/etc/ssl \
  --volume ./../../config/nginx/conf.d:/etc/nginx/conf.d \
  --publish 0.0.0.0:"${ports[0]}":"${ports[0]}" \
  --publish 0.0.0.0:"${ports[1]}":"${ports[1]}" \
  "${image}" &>/dev/null