#!/bin/bash

source utils/repo-check.sh

# Install necessery packages and setup

username="$USER"

sudo groupadd docker
sudo usermod -aG docker "$username"

sudo apt update
sudo apt upgrade -y

sudo mkdir -p -m 755 /etc/apt/keyrings && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

sudo apt install -y gh firewalld

sudo systemctl enable --now firewall-cmd

hasDocker=$(sudo docker -v)

if [ ! "${hasDocker}" ];
then
  curl -sSL https://get.docker.com/ | CHANNEL=stable bash
fi

sudo systemctl enable --now docker
sudo systemctl enable --now containerd