#!/bin/bash

source utils/repo-check.sh

# Run a containerized NGINX

ports=(80 443)
image="nginx:latest"

source utils/port-check.sh "${ports[0]}" "${ports[1]}"

docker pull "$image"

docker container stop nginx &>/dev/null
docker container rm nginx &>/dev/null

docker run                                      \
  --detach                                      \
  --name nginx                                  \
  --publish 0.0.0.0:"${ports[0]}":"${ports[0]}" \
  --publish 0.0.0.0:"${ports[1]}":"${ports[1]}" \
  --restart always                              \
  "$image"