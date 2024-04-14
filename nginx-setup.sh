#!/bin/bash

source utils/repo-check.sh

# Run a containerized NGINX

ports=(80 443)

source utils/port-check.sh "${ports[0]}" "${ports[1]}"

docker pull nginx/nginx:latest

docker container stop nginx || true
docker container rm nginx || true

docker run                                      \
  --detach                                      \
  --name nginx                                  \
  --publish 0.0.0.0:"${ports[0]}":"${ports[0]}" \
  --publish 0.0.0.0:"${ports[1]}":"${ports[1]}" \
  --restart always                              \
  nginx/nginx:latest