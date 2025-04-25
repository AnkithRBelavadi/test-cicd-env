#!/bin/bash
set -e

DIR="/root/app"

if [ -d "$DIR" ]; then
  echo "Directory $DIR already exists. Skipping creation."
else
  echo "Directory $DIR does not exist. Creating now..."
  mkdir -p "$DIR"
  echo "Directory $DIR created successfully."
fi
