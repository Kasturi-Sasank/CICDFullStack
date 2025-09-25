#!/bin/bash

# Load environment variables
set -a
source .env
set +a

# Pull the latest Docker images
docker pull ${DOCKER_HUB_USERNAME}/savenserve-frontend:latest
docker pull ${DOCKER_HUB_USERNAME}/savenserve-backend:latest

# Stop and remove existing containers
docker-compose -f docker-compose.prod.yml down

# Start the containers with the new images
docker-compose -f docker-compose.prod.yml up -d

# Clean up unused images
docker image prune -f