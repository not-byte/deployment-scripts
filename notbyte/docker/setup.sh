#!/bin/bash

docker container prune --force &>/dev/null
docker image prune --force &>/dev/null

# Create a Internal Bridged Network

network="portainer"

docker network rm "${network}" &>/dev/null

docker network create \
  --driver=bridge \
  --subnet=23.0.0.0/16 \
  --ip-range=23.0.0.0/30 \
  --gateway=23.0.0.1 \
  "${network}" &>/dev/null

# Run a containerized Portainer Panel

name="portainer"
image="portainer/portainer-ce"

docker pull "${image}" &>/dev/null

docker stop "${name}" &>/dev/null
docker rm "${name}" &>/dev/null

docker volume remove "${name}" &>/dev/null

docker volume create "${name}" &>/dev/null

docker run \
  --name "${name}" \
  --detach \
  --restart always \
  --network "web" \
  --ip 20.0.3.1 \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --volume "${name}":/data \
  --volume /etc/ssl:/etc/ssl \
  "${image}" &>/dev/null \
  --sslcert /etc/ssl/certs/notbyte.com.pem \
  --sslkey /etc/ssl/private/notbyte.com.pem

docker network connect \
  --ip 23.0.0.2 \
  "${network}" \
  "${name}" &>/dev/null