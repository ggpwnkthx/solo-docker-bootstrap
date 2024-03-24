#! /bin/bash

# Function to generate hashed password
hash_password() {
  echo "$1" | htpasswd -niB user | cut -d: -f2
}

# Load the .env file
if [ -f ".env" ]; then
    export $(cat .env | sed 's/#.*//g' | xargs)
else
    echo "Error: .env file not found."
fi

# Check for PRIMARY_DOMAIN_NAME
if [ ! $PRIMARY_DOMAIN_NAME ]; then
  echo "PRIMARY_DOMAIN_NAME not found in .env file."
  read -p "Enter a primary domain name to use: " primary_domain_name
  echo
  # Replace or append ADMIN_PASSWORD in .env file
  if grep -q "^PRIMARY_DOMAIN_NAME=" .env; then
    # Use the 'sed' command to replace the line
    sed -i "/^PRIMARY_DOMAIN_NAME=/c\PRIMARY_DOMAIN_NAME=$primary_domain_name" .env
  else
    # Append the hashed PRIMARY_DOMAIN_NAME to .env file
    echo "PRIMARY_DOMAIN_NAME=$primary_domain_name" >> .env
  fi
fi

# Check for ACME_EMAIL
if [ ! $ACME_EMAIL ]; then
  echo "ACME_EMAIL not found in .env file."
  read -p "Enter an email address to use: " acme_email
  echo
  # Replace or append ADMIN_PASSWORD in .env file
  if grep -q "^ACME_EMAIL=" .env; then
    # Use the 'sed' command to replace the line
    sed -i "/^ACME_EMAIL=/c\ACME_EMAIL=$acme_email" .env
  else
    # Append the hashed ACME_EMAIL to .env file
    echo "ACME_EMAIL=$acme_email" >> .env
  fi
fi

# Check for ADMIN_PASSWORD
if [ ! $ADMIN_PASSWORD ]; then
  echo "ADMIN_PASSWORD not found in .env file."
  read -sp "Enter the admin password to use: " admin_password
  echo
  hashed_password=$(generate_hashed_password "$admin_password")
  # Replace or append ADMIN_PASSWORD in .env file
  if grep -q "^ADMIN_PASSWORD=" .env; then
    # Use the 'sed' command to replace the line
    sed -i "/^ADMIN_PASSWORD=/c\ADMIN_PASSWORD=$hashed_password" .env
  else
    # Append the hashed ADMIN_PASSWORD to .env file
    echo "ADMIN_PASSWORD=$hashed_password" >> .env
  fi
fi
