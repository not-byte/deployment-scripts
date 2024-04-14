#!/bin/bash

# Setup NGINX in Docker

source port-check.sh

docker pull nginx

docker container stop nginx || true
docker container rm nginx || true

docker run                                      \
  --detach                                      \
  --name nginx                                  \
  --publish 0.0.0.0:"${ports[0]}":"${ports[0]}" \
  --publish 0.0.0.0:"${ports[1]}":"${ports[1]}" \
  --restart always                              \
  nginx