#!/bin/bash

# Check if the script is being run as root or with sudo
if [ "$EUID" -eq 0 ]; then
  echo "This script should not be run as root or with sudo."
  exit 1
fi

# Check if the user has sudo permissions
if sudo -l &> /dev/null; then
  echo "User has sudo permissions. Continuing..."
else
  echo "User does not have sudo permissions. Exiting..."
  exit 1
fi

# Handle prerequisites
/bin/bash ./scripts/preflight.sh

(newgrp docker << 'EOF'
/bin/bash ./scripts/env.sh
docker compose up -d
EOF
)