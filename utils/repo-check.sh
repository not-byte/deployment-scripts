#!/bin/bash

# Check GitHub repository for updates

cd ~/deployment-scripts || exit 1

gh repo sync &>/dev/null