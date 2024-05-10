#!/bin/bash

docker container prune --force &>/dev/null
docker image prune --force &>/dev/null

# Create a Internal Bridged Network

network="tournament"

docker network rm "${network}" &>/dev/null

docker network create \
  --driver=bridge \
  --subnet=22.0.0.0/16 \
  --ip-range=22.0.0.0/29 \
  --gateway=22.0.0.1 \
  "${network}" &>/dev/null

# Run a containerized Tournament App

name="tournament-app"
image="ghcr.io/not-byte/${name}:latest"

docker pull "${image}" &>/dev/null

for ((id=1; id<=3; id++)); do
  docker stop "${name}-${id}" &>/dev/null
  docker rm "${name}-${id}" &>/dev/null

  docker run \
    --name "${name}-${id}" \
    --detach \
    --restart always \
    --network "web" \
    --ip 20.0.2."${id}" \
    "${image}" &>/dev/null

  docker network connect \
    --ip 22.0.0."$((id+1))" \
    "${network}" \
    "${name}" &>/dev/null
done