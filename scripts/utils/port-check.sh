#!/bin/bash

# Check if necessary ports are available

ports=("$@")
isMapped="false"

for port in "${ports[@]}";
do
  isMapped=$(sudo lsof -u ^snap_daemon -i TCP:"${port}")
  if [ "${isMapped}" ];
  then
    echo "> Port ${port} is used!"
  else
    sudo firewall-cmd \
      --permanent \
      --add-port="${port}/tcp" \
      &>/dev/null
  fi
done

if [ "${isMapped}" ];
then
  echo "> Stop services using necessary ports!"
  exit 1
else
  sudo firewall-cmd --reload &>/dev/null
fi