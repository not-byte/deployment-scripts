#!/bin/bash

# Check GitHub repository for updates

repository="deployment-scripts"

cd ~/"${repository}" || exit 1

git pull &>/dev/null

crontab crontab || exit 1

echo "[$(date '+%Y-%m-%d %H:%M:%S')]: Repository ${repository} updated successfully."