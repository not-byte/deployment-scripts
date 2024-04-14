#!/bin/bash

# Run multiple-instance of Cockroach Database

image="cockroachdb/cockroach"
subnet="notroach"
clusters=3

docker pull "${image}"

docker network create -d bridge "${subnet}"

for roach in $(seq 1 "${subnet}");
do
  name="${subnet}-${roach}"
  joined=""
  for sub in $(seq 1 "${clusters}");
  do
    joined="${subnet}-${sub}:26357,${joined}"
  done
  docker volume create "${name}"
  docker run                                     \
    --detach                                     \
    --name "${name}"                               \
    --hostname="${subnet}"                         \
    --net="${subnet}"                                 \
    --publish "2625${roach}:2625${roach}"      \
    --volume "${name}:/cockroach/cockroach-data" \
    --restart always                           \
    "$image" \
    start \
      --advertise-addr="${name}:26357" \
      --http-addr="${name}:808${roach}" \
      --listen-addr="${name}:26357" \
      --sql-addr="${name}:2625${roach}" \
      --insecure \
      --join="${joined}"

done

docker exec -it "${subnet}-1" ./cockroach --host=${subnet}-1:26357 init --insecure