#!/bin/bash

# Check if necessary ports are available

source repo-check.sh

isMapped="false"
ports=("$@")

for port in "${ports[@]}";
do
  sudo firewall-cmd          \
    --permanent              \
    --add-port="${port}/tcp" \
    &>/dev/null
  isMapped=$(sudo lsof -i TCP:"${port}")
  if [ "${isMapped}" ];
  then
    echo "> Port ${port} is used!"
  fi
done

if [ "${isMapped}" ];
then
  echo "> Stop services using necessary ports!"
  exit 1
fi

sudo firewall-cmd --reload