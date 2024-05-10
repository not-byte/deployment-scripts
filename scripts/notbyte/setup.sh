#!/bin/bash

docker container prune --force &>/dev/null
docker image prune --force &>/dev/null

# Run a containerized notByte Website

network="bridge"

name="notbyte-website"
image="ghcr.io/not-byte/${name}:latest"

docker pull "${image}" &>/dev/null

docker stop "${name}" &>/dev/null
docker rm "${name}" &>/dev/null

docker run \
  --name "${name}" \
  --detach \
  --restart always \
  --network "${network}" \
  --ip 172.168.0.3 \
  "${image}" &>/dev/null