#!/bin/bash

# Run a containerized NGINX

image="nginx:latest"
ports=(80 443)

source utils/port-check.sh "${ports[0]}" "${ports[1]}"

docker pull "$image" &>/dev/null

docker prune --force
docker image prune --force

docker stop nginx &>/dev/null
docker rm nginx &>/dev/null

docker run                                      \
  --detach                                      \
  --name nginx                                  \
  --publish 0.0.0.0:"${ports[0]}":"${ports[0]}" \
  --publish 0.0.0.0:"${ports[1]}":"${ports[1]}" \
  --restart always                              \
  "$image"