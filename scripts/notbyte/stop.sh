#!/bin/bash

docker container prune --force &>/dev/null
docker image prune --force &>/dev/null

# Stop a containerized notByte Website

name="notbyte-website"

docker stop "${name}" &>/dev/null
docker rm "${name}" &>/dev/null