#!/bin/bash

# Check GitHub repository for updates

repository="deployment-scripts"
hasChanged="false"

cd ~/"${repository}" || exit 1

git fetch

git status -uno | grep -q "behind" && hasChanged="true"

if [ "${hasChanged}" ];
then
  git pull &>/dev/null

  crontab crontab || exit 1

  message="[$(date '+%Y-%m-%d %H:%M:%S')]: Repository ${repository} updated successfully."

  write "${message}"
  echo "${message}"
fi