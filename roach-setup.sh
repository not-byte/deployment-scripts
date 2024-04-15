#!/bin/bash

# Run n-instances of Cockroach Database

image="cockroachdb/cockroach"
subnet="notroach"
controller="${subnet}-1"
port=60009

if [ "$1" ];
then
    clusters=$1
else
    clusters=3
fi

docker pull "${image}" &>/dev/null

docker network create -d bridge "${subnet}" &>/dev/null

docker container prune --force &>/dev/null
docker image prune --force &>/dev/null

joined="${controller}:${port}"

for ((roach=1; roach<=clusters; roach++));
do
  if [ "${roach}" -ne 1 ];
  then
    joined="${joined},${subnet}-${roach}:${port}"
  fi

  name="${subnet}-${roach}"

  docker stop "${name}" &>/dev/null
  docker rm "${name}" &>/dev/null

  docker volume create "${name}" &>/dev/null

  docker run                                     \
    --detach                                     \
    --name "${name}"                             \
    --hostname "${subnet}-${roach}"              \
    --net "${subnet}"                            \
    --publish "6000${roach}:6000${roach}"        \
    --publish "6000${roach+3}:6000${roach+3}"    \
    --volume "${name}:/cockroach/cockroach-data" \
    --restart always                             \
    "$image"                                     \
    start                                        \
    --advertise-addr="${name}:${port}"           \
    --http-addr="${name}:6000${roach+3}"         \
    --listen-addr="${name}:${port}"              \
    --sql-addr="${name}:6000${roach}"            \
    --join="${joined}"                           \
    --insecure &>/dev/null
done

docker exec                       \
  -it "${controller}" ./cockroach \
  --host="${controller}:${port}"  \
  init                            \
  --insecure