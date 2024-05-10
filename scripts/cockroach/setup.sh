#!/bin/bash

# Run n-instances of Cockroach Database

image="cockroachdb/cockroach"
subnet="not-roach"
controller="${subnet}-1"

if [ "$1" ]; then
  clusters=$1
else
  clusters=3
fi

source utils/port-check.sh 60008

docker pull "${image}" &>/dev/null

docker network create -d bridge "${subnet}" &>/dev/null

docker container prune --force &>/dev/null
docker image prune --force &>/dev/null

joined="${controller}:26357"

for ((roach=2; roach<=clusters; roach++)); do
  joined="${joined},${subnet}-${roach}:26357"
done

docker stop "${controller}" &>/dev/null
docker rm "${controller}" &>/dev/null

docker volume create "${controller}" &>/dev/null

docker run                                           \
  --detach                                           \
  --name "${controller}"                             \
  --restart always                                   \
  --hostname "${controller}"                         \
  --net "${subnet}"                                  \
  --publish "60008:8081"                            \
  --publish "60009:26257"                            \
  --volume "${controller}:/cockroach/cockroach-data" \
  "$image"                                           \
  start                                              \
  --advertise-addr="${controller}:26357"             \
  --http-addr="${controller}:8081"                  \
  --listen-addr="${controller}:26357"                \
  --sql-addr="${controller}:26257"                   \
  --join="${joined}"                                 \
  --insecure &>/dev/null

for ((roach=2; roach<=clusters; roach++)); do
  name="${subnet}-${roach}"
  sql=$((26257+roach-1))

  docker stop "${name}" &>/dev/null
  docker rm "${name}" &>/dev/null

  docker volume create "${name}" &>/dev/null

  docker run                                     \
    --name "${name}"                             \
    --detach                                     \
    --restart always                             \
    --hostname "${subnet}-${roach}"              \
    --net "${subnet}"                            \
    --volume "${name}:/cockroach/cockroach-data" \
    "$image"                                     \
    start                                        \
    --advertise-addr="${name}:26357"             \
    --listen-addr="${name}:26357"                \
    --sql-addr="${name}:${sql}"                  \
    --join="${joined}"                           \
    --insecure &>/dev/null
done

docker exec                           \
  -it "${controller}" ./cockroach     \
  --host="${controller}:26357" \
  init                                \
  --insecure
