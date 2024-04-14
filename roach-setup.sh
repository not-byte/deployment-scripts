#!/bin/bash

# Run multiple-instance of Cockroach Database

image="cockroachdb/cockroach"
subnet="notroach"
clusters=3

docker pull "${image}"

docker network create -d bridge "${subnet}"

joined="${subnet}-${sub}:60009"

for ((sub=clusters-1; sub>=0; sub--));
do
  joined="${joined},${subnet}-${sub}:60009"
done

for ((roach=1; roach<=clusters; roach++));
do
  name="${subnet}-${roach}"
  echo "${name}:2625${roach}"

  docker stop "${name}"
  docker rm "${name}"

  docker volume create "${name}"

  docker run                                      \
    --detach                                      \
    --name "${name}"                              \
    --hostname="${subnet}-${roach}"               \
    --net="${subnet}"                             \
    --publish "127.0.0.1:808${roach}:808${roach}" \
    --publish "0.0.0.0:2625${roach}:2625${roach}" \
    --volume "${name}:/cockroach/cockroach-data"  \
    --restart always                              \
    "$image"                                      \
    start                                         \
    --advertise-addr="${name}:60009"              \
    --http-addr="${name}:808${roach}"             \
    --listen-addr="${name}:60009"                 \
    --sql-addr="${name}:2625${roach}"             \
    --insecure                                    \
    --join="${joined}"
done

docker exec                               \
  -it "${subnet}-1" ./cockroach           \
  --host="${subnet}-1:60009"              \
  init                                    \
  --insecure