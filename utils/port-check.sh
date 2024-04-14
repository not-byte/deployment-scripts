#!/bin/bash

# Check if necessary ports are available

isMapped="false"
ports=("$@")

for port in "${ports[@]}";
do
  isMapped=$(sudo lsof -i TCP:"${port}")
  if [ "${isMapped}" ];
  then
    echo "> Port ${port} is used!"
  else
    sudo firewall-cmd          \
      --permanent              \
      --add-port="${port}/tcp" \
      &>/dev/null
  fi
done

if [ "${isMapped}" ];
then
  echo "> Stop services using necessary ports!"
  exit 1
else
  sudo firewall-cmd --reload
fi