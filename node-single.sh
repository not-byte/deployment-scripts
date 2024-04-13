#!/bin/bash

image="ghcr.io/"$1":latest"
name=$2
port=$3

docker pull $image

docker container prune --force
docker image prune --force

docker container stop $name || true
docker container rm $name || true

docker run -dp 127.0.0.1:$port:3000 --name $name $image
