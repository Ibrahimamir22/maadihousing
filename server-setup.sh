#!/bin/bash

# Maadi Housing - Server Setup Script
# Run this FIRST on a fresh Ubuntu/Debian server

set -e

echo "🖥️  Maadi Housing - Server Setup"
echo "==============================="

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: Please run as root (sudo)${NC}"
    exit 1
fi

echo -e "${BLUE}📦 Updating system...${NC}"
apt update && apt upgrade -y

echo -e "${BLUE}🐳 Installing Docker...${NC}"
apt install -y docker.io docker-compose-v2 curl wget git ufw

# Start and enable Docker
systemctl start docker
systemctl enable docker

echo -e "${BLUE}🔥 Configuring firewall...${NC}"
ufw --force enable
ufw allow ssh
ufw allow 80
ufw allow 443

echo -e "${BLUE}📁 Creating project directory...${NC}"
mkdir -p /var/www/maadihousing
cd /var/www/maadihousing

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✅ SERVER SETUP COMPLETE!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${GREEN}📋 Next steps:${NC}"
echo -e "${GREEN}   1. Upload your project files${NC}"
echo -e "${GREEN}   2. Run: chmod +x deploy.sh${NC}"
echo -e "${GREEN}   3. Run: ./deploy.sh${NC}"
echo ""
echo -e "${BLUE}🔧 Your server is ready for deployment!${NC}"
