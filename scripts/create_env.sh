#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

echo "Fetching environment variables from AWS SSM..."

# Define the SSM parameter names (adjust these as per your actual parameter names)
PARAM_APP_NAME="/APP_NAME"
PARAM_DEBUG="/DEBUG"
PARAM_PORT="/PORT"

# Fetch parameters from SSM Parameter Store with decryption
APP_NAME=$(aws ssm get-parameter --name "$PARAM_APP_NAME" --with-decryption --query "Parameter.Value" --output text)
DEBUG=$(aws ssm get-parameter --name "$PARAM_DEBUG" --with-decryption --query "Parameter.Value" --output text)
PORT=$(aws ssm get-parameter --name "$PARAM_PORT" --with-decryption --query "Parameter.Value" --output text)

# Navigate to your app directory - update this path to your actual app location
APP_DIR="/home/ec2-user/your-app-folder"
cd "$APP_DIR" || { echo "Failed to cd into $APP_DIR"; exit 1; }

# Create or overwrite the .env file with fetched variables
cat > .env <<EOL
APP_NAME=$APP_NAME
DEBUG=$DEBUG
PORT=$PORT
EOL

echo ".env file created successfully at $APP_DIR/.env"
