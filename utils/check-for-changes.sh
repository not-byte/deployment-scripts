#!/bin/bash

# Check GitHub repository for updates

repository="deployment-scripts"
changed="false"

cd ~/"${repository}" || exit 1

git fetch

git status -uno | grep -q "behind" && changed="true"

echo "${changed}"

if [ "${changed}" ];
then
  git pull &>/dev/null

  crontab crontab || exit 1

  message="[$(date '+%Y-%m-%d %H:%M:%S')]: Repository ${repository} updated successfully."

  echo "${message}"
fi