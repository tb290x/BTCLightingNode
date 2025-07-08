#!/bin/bash

# Update and install basics
sudo apt update
sudo apt install -y tmux unzip curl wget gnupg software-properties-common

# Add Bitcoin PPA and install bitcoind
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt update
sudo apt install -y bitcoind

# Install Go (needed for LND)
wget https://go.dev/dl/go1.21.1.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.1.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

# Download and install LND
wget https://github.com/lightningnetwork/lnd/releases/download/v0.18.0-beta/lnd-linux-amd64-v0.18.0-beta.tar.gz
tar -xzf lnd-linux-amd64-v0.18.0-beta.tar.gz
sudo install -m 0755 -o root -g root -t /usr/local/bin lnd-linux-amd64-v0.18.0-beta/*