#!/bin/bash

# Check for updates in GitHub repository

repository="deployment-scripts"
changed=false

cd ~/"${repository}" || exit 1

git fetch &>/dev/null

git status -uno | grep -q "behind" && changed=true

if [ $changed = true ];
then
  git pull &>/dev/null

  crontab crontab || exit 1

  message="[$(date '+%Y-%m-%d %H:%M:%S')]: Repository ${repository} updated successfully."

  echo "${message}"
fi