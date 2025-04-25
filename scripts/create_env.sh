#!/bin/bash

set -e  # Exit on any error

echo "Fetching environment variables from AWS SSM..."

# Define the SSM parameter names
PARAM_APP_NAME="/APP_NAME"
PARAM_DEBUG="/DEBUG"
PARAM_PORT="/PORT"

# Fetch parameters
APP_NAME=$(aws ssm get-parameter --name "$PARAM_APP_NAME" --with-decryption --query "Parameter.Value" --output text)
DEBUG=$(aws ssm get-parameter --name "$PARAM_DEBUG" --with-decryption --query "Parameter.Value" --output text)
PORT=$(aws ssm get-parameter --name "$PARAM_PORT" --with-decryption --query "Parameter.Value" --output text)

# Set app directory
APP_DIR="/root/app"

# Create the .env file
cat > "$APP_DIR/.env" <<EOF
APP_NAME=$APP_NAME
DEBUG=$DEBUG
PORT=$PORT
EOF

echo ".env file created successfully at $APP_DIR/.env"

# Activate virtual environment if needed (optional)
# source $APP_DIR/venv/bin/activate

# Start the FastAPI app using uvicorn
cd "$APP_DIR"
echo "Starting FastAPI app..."
nohup uvicorn main:app --host 0.0.0.0 --port "$PORT" > "$APP_DIR/app.log" 2>&1 &
