#!/bin/bash

# Doing this in a separate script lets us do it step by step while using a
# single docker layer.

# Install tools
yum remove -y vim-minimal
yum install -y epel-release
yum install -y \
    sudo \
    git \
    ansible \
    python-pip \
    htop \
    vim-enhanced

# Install Oh-my-zsh
# curl -sSL http://install.ohmyz.sh | sh

# Add personal user
adduser gbraad
echo "gbraad ALL=(root) NOPASSWD:ALL" | tee -a /etc/sudoers.d/gbraad
chmod 0440 /etc/sudoers.d/gbraad
sed -i 's/Defaults    requiretty/Defaults    !requiretty/g' /etc/sudoers

# Install personal dotfiles
curl -sSL https://raw.githubusercontent.com/gbraad/dotfiles/master/install.yml -o /tmp/install.yml
su - gbraad -c "ansible-playbook /tmp/install.yml"

# Clean up
sed -i 's/Defaults    !requiretty/Defaults    requiretty/g' /etc/sudoers
yum clean all
