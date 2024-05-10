#!/bin/bash

docker container prune --force &>/dev/null
docker image prune --force &>/dev/null

# Stop a containerized Tournament App

network="tournament"
name="tournament-app"

docker network rm "${network}" &>/dev/null

for ((id=1; id<=3; id++)); do
  docker stop "${name}-${id}" &>/dev/null
  docker rm "${name}-${id}" &>/dev/null
done