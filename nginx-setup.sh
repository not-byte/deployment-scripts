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

docker run                                                            \
  --name nginx                                                        \
  --detach                                                            \
  --restart always                                                    \
  --network nginx                                                     \
  --volume /etc/ssl:/etc/ssl                                          \
  --volume ./nginx/conf.d/default.conf:/etc/nginx/conf.d/default.conf \
  --publish 0.0.0.0:"${ports[0]}":"${ports[0]}"                       \
  --publish 0.0.0.0:"${ports[1]}":"${ports[1]}"                       \
  "$image" &>/dev/null