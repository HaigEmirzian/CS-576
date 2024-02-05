#!/bin/bash

#=================================================================
# Most cloud platforms create a default account in the system.
# We will not use this account for SEED labs. Instead, we will
# create a new account called "seed", give it the privilege
# to run "sudo" commands. 
#=================================================================

#================================================
# Create a user account called "seed" if it does not exist. 
# For security, we will not set the password for this account, 
#   so nobody can ssh directly into this account. You need to 
#   set up public keys to ssh directly into this account.
sudo useradd -m -s /bin/bash seed 

# Allow seed to run sudo commands without password
sudo cp Files/System/seed_sudoers  /etc/sudoers.d/
sudo chmod 440 /etc/sudoers.d/seed_sudoers

# Set the USERID shell variable.
USERID=seed

#================================================
echo "Installing various tools ..."

sudo apt update

#------------------------------------------------
# Networking Tools

sudo apt -y install telnetd
#sudo apt -y install traceroute
sudo apt -y install openbsd-inetd

# net-tools include arp, ifconfig, netstat, route etc.
#sudo apt -y install net-tools

# For Firewalls lab
sudo apt -y install conntrack

# For DNS
sudo apt -y install resolvconf

# Install browser
#sudo apt -y install firefox

#------------------------------------------------
# Utilities

sudo apt -y install bless
sudo apt -y install ent
sudo apt -y install execstack
sudo apt -y install gcc-multilib
#sudo apt -y install gdb
sudo apt -y install ghex
sudo apt -y install libpcap-dev
#sudo apt -y install nasm
#sudo apt -y install unzip
#sudo apt -y install whois
#sudo apt -y install zip
#sudo apt -y install zsh

# Install vscode 
#sudo snap install --classic code
# rather than using snap, grab code-oss
#
#  https://www.kali.org/tools/code-oss
sudo apt -y install code-oss

# emacs, anyone?
sudo apt -y install emacs

# sudo apt -y install vim  (already in the system)
# sudo apt -y install git  (already in the system)
# sudo apt -y install curl (already in the system)
# sudo apt -y install tcpdump (already in the system)

#================================================
# Python3.8 is already in the OS
echo "Installing Python and modules ..."

# Install pip3 and Python3 modules 
#sudo apt -y install python3-pip
#sudo pip3 install scapy
#sudo pip3 install pycryptodome


#================================================
echo "Installing miscellaneous tools ..."

# Install gdbpeda (gdb plugin)
git clone https://github.com/longld/peda.git /tmp/gdbpeda
sudo cp -r /tmp/gdbpeda /opt
rm -rf /tmp/gdbpeda

#================================================
echo "Installing docker utilities ..."
  
# Install docker
sudo apt -y install docker.io

# Start docker and enable it to start after the system reboot:
sudo systemctl enable --now docker

# Optionally give any user administrative privileges to docker:
sudo usermod -aG docker $USERID

# Install docker-compose. Check whether 1.27.4 is the newest version
#
# OLD approach
#
#sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#sudo chmod +x /usr/local/bin/docker-compose
#
# NEW approach
#
# add a custom URL for the docker-ce repository
# -- replace 'bookworm' with the latest stable debian release
printf '%s\n' "deb https://download.docker.com/linux/debian bookworm stable" | sudo tee /etc/apt/sources.list.d/docker-ce.list
# grab the signing key of docker's folks and make it available to APT
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-ce-archive-keyring.gpg
# install docker-ce and friends
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io


#================================================
echo "Installing Wireshark ..."

# Install Wireshark
# Make sure to select 'No' when asked whether non-superuser should be
#      able to capture packets.
sudo apt -y install wireshark
sudo chgrp $USERID /usr/bin/dumpcap
sudo chmod 750 /usr/bin/dumpcap
sudo setcap cap_net_raw,cap_net_admin+eip /usr/bin/dumpcap


#================================================
echo "Customization ..."

HOMEDIR=/home/$USERID

# Change the own of this folder (and all its files) to $USERID,
# because we need to access it from the $USERID account. This 
# guarantees that the "sudo -u $USERID cp Files/..." command will work.
sudo chown -R $USERID Files


# Install gdbpeda (gdb plugin)
sudo -u $USERID cp Files/System/seed_gdbinit $HOMEDIR/.gdbinit

# We have defined a few aliases for the SEED labs
sudo -u $USERID cp Files/System/seed_bash_aliases $HOMEDIR/.bash_aliases

# Customization for Wireshark
sudo -u $USERID mkdir -p $HOMEDIR/.config/wireshark/
sudo -u $USERID cp Files/Wireshark/preferences $HOMEDIR/.config/wireshark/preferences
sudo -u $USERID cp Files/Wireshark/recent $HOMEDIR/.config/wireshark/recent



#================================================
echo "Cleaning up ..."

# Clean up the apt cache 
sudo apt clean
sudo rm -rf /var/lib/apt/lists/*


#================================================
echo "***************************************"
echo "If you want to be able to SSH into the seed account, you need to set up public keys."
echo "You can find the instruction in the manual."
echo "***************************************"


