#!/bin/bash
# Create a internal bridge Network

network="tournament"

docker network rm "${network}" &>/dev/null

docker network create \
  --driver=bridge \
  --subnet=20.0.0.0/16 \
  --ip-range=20.0.0.0/24 \
  --gateway=20.0.0.1 \
  "${network}" &>/dev/null

docker container prune --force &>/dev/null
docker image prune --force &>/dev/null

# Run a containerized NGINX

image="nginx:latest"
name="nginx"
ports=(80 443)

source ../utils/port-check.sh "${ports[0]}" "${ports[1]}"

docker pull "$image" &>/dev/null

docker stop "${name}" &>/dev/null
docker rm "${name}" &>/dev/null

docker run \
  --name "${name}" \
  --restart always \
  --detach \
  --restart always \
  --network "${network}" \
  --ip 20.0.0.2 \
  --volume /etc/ssl:/etc/ssl \
  --volume ./../"${name}"/conf.d:/etc/"${name}"/conf.d \
  --publish 0.0.0.0:"${ports[0]}":"${ports[0]}" \
  --publish 0.0.0.0:"${ports[1]}":"${ports[1]}" \
  "${image}" &>/dev/null

# Run a containerized Node

image="ghcr.io/not-byte/tournament-app:latest"
name="tournament_app"

docker pull "${image}" &>/dev/null

docker stop "${name}" &>/dev/null
docker rm "${name}" &>/dev/null

docker run \
  --name "${name}" \
  --detach \
  --restart always  \
  --network "${network}" \
  --ip 20.0.0.3 \
  "${image}" &>/dev/null

