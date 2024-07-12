#!/bin/bash

docker container prune --force &>/dev/null
docker image prune --force &>/dev/null

# Create a Internal Bridged Network

network="web"

docker network rm "${network}" &>/dev/null

docker network create \
  --driver=bridge \
  --subnet=20.0.0.0/16 \
  --ip-range=20.0.0.0/16 \
  --gateway=20.0.0.1 \
  "${network}" &>/dev/null

# Run a containerized NGINX Webserver

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
  --ip 20.0.0.2 \
  --volume /etc/ssl:/etc/ssl \
  --volume ./nginx/conf.d:/etc/nginx/conf.d \
  --publish 0.0.0.0:"${ports[0]}":"${ports[0]}" \
  --publish 0.0.0.0:"${ports[1]}":"${ports[1]}" \
  "${image}" &>/dev/null