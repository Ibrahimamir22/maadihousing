#!/bin/bash

# Maadi Housing - Production Deployment Script
# Run this on your server after uploading the project

set -e

echo "🏠 Maadi Housing - Production Deployment"
echo "========================================"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if we're in the right directory
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}Error: docker-compose.yml not found. Are you in the project directory?${NC}"
    exit 1
fi

echo -e "${BLUE}📋 Checking prerequisites...${NC}"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed. Please install Docker first.${NC}"
    echo "Run: sudo apt update && sudo apt install -y docker.io docker-compose-v2"
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "${RED}Error: Docker Compose is not available.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Prerequisites OK${NC}"

# Check if .env exists
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}⚠️  .env file not found. Creating from template...${NC}"
    if [ -f "env.example" ]; then
        cp env.example .env
        echo -e "${YELLOW}📝 Please edit .env file with your production settings${NC}"
        echo -e "${YELLOW}   nano .env${NC}"
        echo ""
        read -p "Press Enter after editing .env file..."
    else
        echo -e "${RED}Error: env.example not found${NC}"
        exit 1
    fi
fi

echo -e "${BLUE}🐳 Building and starting services...${NC}"
docker-compose down 2>/dev/null || true
docker-compose up -d --build

echo -e "${BLUE}⏳ Waiting for services to start...${NC}"
sleep 10

echo -e "${BLUE}🗄️  Running database migrations...${NC}"
docker-compose exec -T backend python manage.py migrate

echo -e "${BLUE}👤 Creating admin user...${NC}"
docker-compose exec -T backend python manage.py setup_admin

echo -e "${BLUE}🔍 Checking services status...${NC}"
docker-compose ps

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}🎉 DEPLOYMENT COMPLETE!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${GREEN}🌐 Your site is now live at:${NC}"
echo -e "${GREEN}   http://your-server-ip${NC}"
echo ""
echo -e "${GREEN}🔧 Admin Panel:${NC}"
echo -e "${GREEN}   http://your-server-ip/admin/${NC}"
echo ""
echo -e "${YELLOW}👤 Admin Credentials:${NC}"
echo -e "${YELLOW}   Username: maadihousing${NC}"
echo -e "${YELLOW}   Password: maadihousing${NC}"
echo -e "${YELLOW}   Email: info@maadihousing.com${NC}"
echo ""
echo -e "${BLUE}📊 Useful commands:${NC}"
echo -e "${BLUE}   View logs: docker-compose logs -f${NC}"
echo -e "${BLUE}   Stop: docker-compose down${NC}"
echo -e "${BLUE}   Restart: docker-compose restart${NC}"
echo -e "${BLUE}   Update: git pull && docker-compose up -d --build${NC}"
echo ""
echo -e "${GREEN}🚀 Happy deploying!${NC}"
