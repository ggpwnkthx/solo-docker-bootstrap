#! /bin/bash

# Function to generate hashed password
hash_password() {
  echo "$1" | htpasswd -niB user | cut -d: -f2
}

# Helper function to get value from .env file
get_env_value() {
  grep "^$1=" .env | cut -d'=' -f2
}

# Check for PRIMARY_DOMAIN_NAME
primary_domain_name=$(get_env_value PRIMARY_DOMAIN_NAME)
if [ -z "$primary_domain_name" ]; then
  echo "PRIMARY_DOMAIN_NAME not found in .env file."
  read -p "Enter a primary domain name to use: " primary_domain_name
  echo
  # Replace or append PRIMARY_DOMAIN_NAME in .env file
  if grep -q "^PRIMARY_DOMAIN_NAME=" .env; then
    sed -i "/^PRIMARY_DOMAIN_NAME=/c\PRIMARY_DOMAIN_NAME=$primary_domain_name" .env
  else
    echo "PRIMARY_DOMAIN_NAME=$primary_domain_name" >> .env
  fi
fi

# Check for ACME_EMAIL
acme_email=$(get_env_value ACME_EMAIL)
if [ -z "$acme_email" ]; then
  echo "ACME_EMAIL not found in .env file."
  read -p "Enter an email address to use: " acme_email
  echo
  # Replace or append ACME_EMAIL in .env file
  if grep -q "^ACME_EMAIL=" .env; then
    sed -i "/^ACME_EMAIL=/c\ACME_EMAIL=$acme_email" .env
  else
    echo "ACME_EMAIL=$acme_email" >> .env
  fi
fi

# Check for ADMIN_PASSWORD
admin_password=$(get_env_value ADMIN_PASSWORD)
if [ -z "$admin_password" ]; then
  echo "ADMIN_PASSWORD not found in .env file."
  read -sp "Enter the admin password to use: " admin_password
  echo
  hashed_password=$(hash_password "$admin_password")
  # Replace or append ADMIN_PASSWORD in .env file
  if grep -q "^ADMIN_PASSWORD=" .env; then
    sed -i "/^ADMIN_PASSWORD=/c\ADMIN_PASSWORD=${hashed_password//\$/\$\$}" .env
  else
    echo "ADMIN_PASSWORD=${hashed_password//\$/\$\$}" >> .env
  fi
fi
