#!/bin/bash

docker container prune --force &>/dev/null
docker image prune --force &>/dev/null

# Create a Internal Bridged Network

network="notbyte"

docker network rm "${network}" &>/dev/null

docker network create \
  --driver=bridge \
  --subnet=21.0.0.0/16 \
  --ip-range=21.0.0.0/30 \
  --gateway=21.0.0.1 \
  "${network}" &>/dev/null

# Run a containerized notByte Website

name="notbyte-website"
image="ghcr.io/not-byte/${name}:latest"

docker pull "${image}" &>/dev/null

docker stop "${name}" &>/dev/null
docker rm "${name}" &>/dev/null

docker run \
  --name "${name}" \
  --detach \
  --restart always \
  --network "web" \
  --ip 20.0.1.1 \
  --network "${network}" \
  --ip 21.0.0.2 \
  "${image}" &>/dev/null