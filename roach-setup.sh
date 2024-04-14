#!/bin/bash

# Run multiple-instance of Cockroach Database

image="cockroachdb/cockroach"
subnet="notroach"
clusters=3

docker pull "${image}"

docker network create -d bridge "${subnet}"

joined="${subnet}-${sub}:26357"

for ((sub=3; sub>=clusters; sub--));
do
  if [ "${sub}" -lt 3 ];
  then
    joined="${joined},${subnet}-${sub}:26357"
    echo "${joined}"
  fi
done

for ((roach=1; sub<=clusters; sub++));
do
  name="${subnet}-${roach}"
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