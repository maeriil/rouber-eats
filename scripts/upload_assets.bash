#!/bin/bash

# Read API key from file
ASPHALT_API_KEY=$(cat .env/ASPHALT_API_KEY.txt)

# Debugging: Print the API key (for testing purposes, remove after verifying)
echo "API Key: $ASPHALT_API_KEY"
