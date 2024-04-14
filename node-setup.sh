#!/bin/bash

# Run a containerized Node

image="ghcr.io/${1}:latest"
name=$2
port=$3

source utils/port-check.sh "${port}"

docker pull "${image}" &>/dev/null

docker container prune --force &>/dev/null
docker image prune --force &>/dev/null

docker stop "${name}" || true
docker rm "${name}" || true

docker run                 \
  --detach                 \
  --name "${name}"         \
  --publish "${port}":3000 \
  --restart always         \
  "${image}" &>/dev/null