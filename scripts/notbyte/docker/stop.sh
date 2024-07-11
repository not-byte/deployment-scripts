#!/bin/bash

docker container prune --force &>/dev/null
docker image prune --force &>/dev/null

# Stop a containerized notByte Website

network="portainer"
name="portainer"

docker network rm "${network}" &>/dev/null

docker stop "${name}" &>/dev/null
docker rm "${name}" &>/dev/null