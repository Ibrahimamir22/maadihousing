#!/bin/bash

# Fix for docker-compose "KeyError: 'ContainerConfig'" and port 80 conflict.
# Run from: /var/www/maadihousing

set -e

echo "Stopping and removing Maadi Housing containers (data is in volumes, safe)..."
docker-compose down

echo "Removing old maadihousing containers by name (in case down left some)..."
docker rm -f maadihousing-backend maadihousing-frontend maadihousing-nginx 2>/dev/null || true

echo "Starting fresh..."
docker-compose up -d --build

echo ""
echo "Checking status..."
docker-compose ps

echo ""
echo "Done. If any service is missing, run: docker-compose up -d --build"
