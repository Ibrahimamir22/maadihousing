#!/bin/bash

# Quick check that Maadi Housing is reachable on 8080 and that nginx is running

set -e
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Checking Maadi Housing..."
echo ""

cd /var/www/maadihousing

# Container count
COUNT=$(docker-compose ps -q 2>/dev/null | wc -l)
if [ "$COUNT" -lt 4 ]; then
    echo -e "${RED}Expected at least 4 containers (db, backend, frontend, nginx). Found: $COUNT${NC}"
    echo "Run: docker-compose up -d --build"
    exit 1
fi

if ! docker-compose ps | grep -q maadihousing-nginx; then
    echo -e "${RED}maadihousing-nginx is not running.${NC}"
    echo "Run: docker-compose up -d --build"
    exit 1
fi

echo -e "${GREEN}All 4 Maadi Housing containers are running.${NC}"
echo ""

# Port 8080
if curl -s -o /dev/null -w "%{http_code}" --connect-timeout 3 http://127.0.0.1:8080 | grep -q "200"; then
    echo -e "${GREEN}Port 8080: OK (Maadi Housing is serving)${NC}"
else
    echo -e "${YELLOW}Port 8080: Not responding yet. Wait a few seconds and run again.${NC}"
fi

echo ""
echo "Next: add maadihousing.com proxy in here-home nginx (see HOSTINGER-DOMAIN-FIX.md)"
