#!/bin/bash

# Setup SEED
sudo apt-get update
sudo apt-get -y upgrade
cd src && ./install.sh

# Install SEED labs
echo "Installing SEED labs"
cd ~seed
sudo -u seed git clone https://github.com/seed-labs/seed-labs.git
