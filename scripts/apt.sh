#! /bin/bash

# Initialize a flag to check if any package is not installed
all_installed=true

# Check if Docker packages are installed
for pkg in htpassword docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin; do
  if ! dpkg -l | grep -qw $pkg; then
    echo "Package $pkg is not installed. Proceeding with installation..."
    all_installed=false
    break
  fi
done

# Exit if all packages are installed
if $all_installed; then
  echo "All specified packages are already installed. Exiting..."
  exit 0
fi

## Uninstall conflicting packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do 
  sudo apt-get remove -y $pkg
done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl htpassword
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install the latest version
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Ensure current user is in the docker group
sudo usermod -aG docker $USER
newgrp docker