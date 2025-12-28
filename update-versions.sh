#!/bin/bash

# Maadi Housing - Version Update Script
# Updates all dependencies to latest versions

set -e

echo "🔄 Updating Maadi Housing to latest versions..."
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}📦 Updating frontend dependencies...${NC}"
cd frontend
npm update
cd ..
echo -e "${GREEN}✓ Frontend dependencies updated${NC}"
echo ""

echo -e "${BLUE}🐍 Updating backend dependencies...${NC}"
cd backend
pip install --upgrade -r requirements.txt
cd ..
echo -e "${GREEN}✓ Backend dependencies updated${NC}"
echo ""

echo -e "${GREEN}🎉 All versions updated to latest!${NC}"
echo ""
echo "Run 'docker-compose up -d --build' to rebuild with latest versions."
