#!/bin/bash

docker container prune --force &>/dev/null
docker image prune --force &>/dev/null

# Run a containerized notByte Website

name="notbyte-website"
image="ghcr.io/not-byte/${name}"

docker pull "${image}" &>/dev/null

docker stop "${name}" &>/dev/null
docker rm "${name}" &>/dev/null

docker run \
  --name "${name}" \
  --detach \
  --restart always \
  --network "web" \
  --ip 20.0.1.1 \
  "${image}" &>/dev/null

docker network connect \
  --ip 21.0.0.2 \
  "${network}" \
  "${name}" &>/dev/null