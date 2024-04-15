#!/bin/bash

# Run n-instances of Cockroach Database

image="cockroachdb/cockroach"
subnet="not-roach"
controller="${subnet}-1"
ports=(26357 8081 26257 60008)

if [ "$1" ];
then
  clusters=$1
else
  clusters=3
fi

if [ "$2" ];
then
  ports[4]=$2
else
  ports[4]=60009
fi

source utils/port-check.sh "${ports[4]}"

docker pull "${image}" &>/dev/null

docker network create -d bridge "${subnet}" &>/dev/null

docker container prune --force &>/dev/null
docker image prune --force &>/dev/null

joined="${controller}:${ports[0]}"

for ((roach=2; roach<=clusters; roach++));
do
    joined="${joined},${subnet}-${roach}:${ports[0]}"
done

docker stop "${controller}" &>/dev/null
docker rm "${controller}" &>/dev/null

docker volume create "${controller}" &>/dev/null

docker run                                           \
  --detach                                           \
  --name "${controller}"                             \
  --hostname "${controller}"                         \
  --net "${subnet}"                                  \
  --publish "${ports[3]}:${ports[1]}"                \
  --publish "${ports[4]}:${ports[2]}"                \
  --volume "${controller}:/cockroach/cockroach-data" \
  --restart always                                   \
  "$image"                                           \
  start                                              \
  --advertise-addr="${controller}:${ports[0]}"       \
  --http-addr="${controller}:${ports[1]}"            \
  --listen-addr="${controller}:${ports[0]}"          \
  --sql-addr="${controller}:${ports[2]}"             \
  --join="${joined}"                                 \
  --insecure

for ((roach=2; roach<=clusters; roach++));
do
  name="${subnet}-${roach}"
  sql="$((ports[2]+roach-1))"

  docker stop "${name}" &>/dev/null
  docker rm "${name}" &>/dev/null

  docker volume create "${name}" &>/dev/null

  docker run                                     \
    --detach                                     \
    --name "${name}"                             \
    --hostname "${subnet}-${roach}"              \
    --net "${subnet}"                            \
    --volume "${name}:/cockroach/cockroach-data" \
    --restart always                             \
    "$image"                                     \
    start                                        \
    --advertise-addr="${name}:${ports[0]}"       \
    --listen-addr="${name}:${ports[0]}"          \
    --sql-addr="${name}:${sql}"                  \
    --join="${joined}"                           \
    --insecure
done

docker exec                          \
  -it "${controller}" ./cockroach    \
  --host="${controller}:${ports[0]}" \
  init                               \
  --insecure