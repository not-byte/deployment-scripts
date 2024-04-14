#!/bin/bash

# Run n-instances of Cockroach Database

image="cockroachdb/cockroach"
subnet="notroach"

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

joined="${subnet}-1:60009"

for ((sub=0; sub<clusters; sub++));
do
  joined="${joined},${subnet}-${sub}:60009"
done

for ((roach=1; roach<=clusters; roach++));
do
  name="${subnet}-${roach}"

  docker stop "${name}" &>/dev/null
  docker rm "${name}" &>/dev/null

  docker volume create "${name}" &>/dev/null

  docker run                                     \
    --detach                                     \
    --name "${name}"                             \
    --hostname="${subnet}-${roach}"              \
    --net="${subnet}"                            \
    --publish "2625${roach}:2625${roach}"        \
    --publish "808${roach}:808${roach}"          \
    --volume "${name}:/cockroach/cockroach-data" \
    --restart always                             \
    "$image"                                     \
    start                                        \
    --advertise-addr="${name}:60009"             \
    --http-addr="${name}:808${roach}"            \
    --listen-addr="${name}:60009"                \
    --sql-addr="${name}:2625${roach}"            \
    --insecure                                   \
    --join="${joined}" &>/dev/null
done

echo "${joined}"

docker exec                     \
  -it "${subnet}-1" ./cockroach \
  --host="0.0.0.0:60009"        \
  init                          \
  --insecure &>/dev/null