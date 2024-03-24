#!/bin/bash

# Get the operating system name
os_name=$(uname -s)

echo "Operating System: $os_name"

run_script_based_on_package_manager() {
  package_manager=$1
  case $package_manager in
    apt)
      echo "Running script for apt package manager..."
      /bin/bash ./scripts/apt.sh
      ;;
    dnf)
      echo "Running script for dnf package manager..."
      /bin/bash ./scripts/dnf.sh
      ;;
    yum)
      echo "Running script for yum package manager..."
      /bin/bash ./scripts/yum.sh
      ;;
    pacman)
      echo "Running script for pacman package manager..."
      /bin/bash ./scripts/pacman.sh
      ;;
    *)
      echo "Package manager not supported or identified."
      ;;
  esac
}

# If the operating system is Linux, attempt to identify the distribution
if [ "$os_name" = "Linux" ]; then
  echo "Identifying Linux distribution..."

  if [ -f /etc/os-release ]; then
    . /etc/os-release
    case $ID in
      debian|ubuntu|linuxmint)
        run_script_based_on_package_manager apt
        ;;
      fedora)
        run_script_based_on_package_manager dnf
        ;;
      centos|rhel)
        VERSION_ID=${VERSION_ID%%.*} # Get major version number by truncating at the dot
        if [ "$VERSION_ID" -ge 8 ]; then
          run_script_based_on_package_manager dnf
        else
          run_script_based_on_package_manager yum
        fi
        ;;
      arch|manjaro)
        run_script_based_on_package_manager pacman
        ;;
      *)
        echo "Distribution $ID not explicitly supported by this script."
        ;;
    esac
  else
    echo "Unable to identify Linux distribution using /etc/os-release."
  fi
else
  echo "This script is intended for identifying and handling Linux distributions."
fi
