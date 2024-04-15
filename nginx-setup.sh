#!/bin/bash

# Run a containerized NGINX

image="nginx:latest"
ports=(80 443)

source utils/port-check.sh "${ports[0]}" "${ports[1]}"

docker pull "$image" &>/dev/null

docker container prune --force &>/dev/null
docker image prune --force &>/dev/null

docker stop nginx &>/dev/null
docker rm nginx &>/dev/null

docker run                                                                       \
  --detach                                                                       \
  --name nginx                                                                   \
  --volume /etc/ssl:/etc/ssl                                                     \
  --volume ~/deployment-scripts/nginx/sites-available:/etc/nginx/sites-available \
  --volume ~/deployment-scripts/nginx/sites-enabled:/etc/nginx/sites-enabled     \
  --publish "${ports[0]}":"${ports[0]}"                                          \
  --publish "${ports[1]}":"${ports[1]}"                                          \
  --restart always                                                               \
  "$image" &>/dev/null