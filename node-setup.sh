#!/bin/bash

# Run a containerized Node

image="ghcr.io/$1:latest"
name=$2
port=$3

source utils/port-check.sh "$port"

docker pull "$image"

docker container prune --force
docker image prune --force

docker container stop "$name" || true
docker container rm "$name" || true

docker run                         \
  --detach                         \
  --name "$name"                   \
  --publish 127.0.0.1:"$port":3000 \
  --restart always                 \
  "$image"