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

# Install Python 3 and pip if not present
echo "Installing Python and tools..."
apt update
apt install -y python3 python3-pip python3-venv

# Create virtual environment
if [ ! -d "$APP_DIR/venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv "$APP_DIR/venv"
fi

# Activate the virtual environment
source "$APP_DIR/venv/bin/activate"

# Install dependencies
if [ -f "$APP_DIR/requirements.txt" ]; then
    echo "Installing dependencies..."
    pip install -r "$APP_DIR/requirements.txt"
else
    echo "requirements.txt not found in $APP_DIR"
    exit 1
fi

# Create .env file
echo "Creating .env file..."
cat > "$APP_DIR/.env" <<EOF
APP_NAME=$APP_NAME
DEBUG=$DEBUG
PORT=$PORT
EOF
echo ".env file created at $APP_DIR/.env"

# Stop previous uvicorn process if any
echo "Stopping old uvicorn process if running..."
pkill -f "uvicorn main:app" || true

# Start FastAPI app
cd "$APP_DIR"
echo "Starting FastAPI app..."
nohup "$APP_DIR/venv/bin/uvicorn" main:app --host 0.0.0.0 --port "$PORT" > /dev/null 2>&1 &
