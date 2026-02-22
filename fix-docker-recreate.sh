#!/bin/bash

# Fix for docker-compose "KeyError: 'ContainerConfig'" and port 80 conflict.
# Run from: /var/www/maadihousing

set -e

echo "Ensure nginx uses 8080 (not 80) to avoid conflict with here-home..."
if grep -q '"80:80"' docker-compose.yml 2>/dev/null || grep -q '80:80' docker-compose.yml 2>/dev/null; then
    echo "Fixing docker-compose.yml: changing 80:80 -> 8080:80 and 443:443 -> 8443:443"
    sed -i.bak 's/"80:80"/"8080:80"/g; s/"443:443"/"8443:443"/g; s/80:80/8080:80/g; s/443:443/8443:443/g' docker-compose.yml
fi

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
