#!/bin/bash

docker pull ghcr.io/$1:latest

image_id=$(docker images --format "{{.ID}}" ghcr.io/$1:latest)

docker container prune --force
docker image prune --force

docker container stop $2 || true
docker container rm $2 || true

docker run -dp 127.0.0.1:$3:3000 --name $2 $image_id
