#!/bin/bash

# Check GitHub repository for updates

repository="deployment-scripts"
changed="false"

cd ~/"${repository}" || exit 1

git fetch

git status -uno | grep -q "up to date" && changed="true"

if [ "${changed}" ];
then
  git pull &>/dev/null

  crontab crontab || exit 1

  message="[$(date '+%Y-%m-%d %H:%M:%S')]: Repository ${repository} updated successfully."

  wall "${message}"
  echo "${message}"
fi