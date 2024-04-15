#!/bin/bash

# Stop n-instances of Cockroach Database

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

docker container prune --force &>/dev/null
docker image prune --force &>/dev/null

for ((roach=1; roach<=clusters; roach++));
do
  name="${subnet}-${roach}"

  docker stop "${name}" &>/dev/null
  docker rm "${name}" &>/dev/null

  docker volume rm "${name}" &>/dev/null
done

docker network rm "${subnet}" &>/dev/null