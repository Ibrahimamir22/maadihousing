#!/bin/bash

# Maadi Housing - Docker Helper Commands
# Useful shortcuts for managing Maadi Housing containers

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🐳 Maadi Housing Docker Commands${NC}"
echo "=========================================="
echo ""
echo -e "${GREEN}📋 View only Maadi Housing containers:${NC}"
echo "   docker-compose ps"
echo ""
echo -e "${GREEN}📋 View all containers (system-wide):${NC}"
echo "   docker ps"
echo ""
echo -e "${GREEN}📋 View Maadi Housing containers (filtered):${NC}"
echo "   docker ps --filter 'name=maadihousing'"
echo ""
echo -e "${GREEN}📊 View logs:${NC}"
echo "   docker-compose logs -f"
echo "   docker-compose logs -f backend"
echo "   docker-compose logs -f frontend"
echo ""
echo -e "${GREEN}🔄 Restart services:${NC}"
echo "   docker-compose restart"
echo "   docker-compose restart backend"
echo ""
echo -e "${GREEN}⏹️  Stop services:${NC}"
echo "   docker-compose stop"
echo ""
echo -e "${GREEN}▶️  Start services:${NC}"
echo "   docker-compose start"
echo ""
echo -e "${GREEN}🛑 Stop and remove containers:${NC}"
echo "   docker-compose down"
echo ""
echo -e "${GREEN}🚀 Start services:${NC}"
echo "   docker-compose up -d"
echo ""
echo -e "${GREEN}🔨 Rebuild and restart:${NC}"
echo "   docker-compose up -d --build"
echo ""
echo -e "${YELLOW}💡 Tip: Always use 'docker-compose' commands when in /var/www/maadihousing${NC}"
echo "   This ensures you're managing only Maadi Housing containers"
echo ""
