#!/bin/bash

# Maadi Housing - SSL Certificate Setup Script
# This script sets up Let's Encrypt SSL certificates for maadihousing.com

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

DOMAIN="maadihousing.com"
EMAIL="info@maadihousing.com"

echo -e "${BLUE}🔒 Setting up SSL certificates for ${DOMAIN}${NC}"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: Please run as root (sudo)${NC}"
    exit 1
fi

# Check if certbot is installed
if ! command -v certbot &> /dev/null; then
    echo -e "${BLUE}📦 Installing certbot...${NC}"
    apt update
    apt install -y certbot python3-certbot-nginx
fi

# Create directories for certbot
echo -e "${BLUE}📁 Creating certbot directories...${NC}"
mkdir -p /var/www/certbot
mkdir -p /etc/letsencrypt
chmod -R 755 /var/www/certbot
chmod -R 755 /etc/letsencrypt

# Make sure nginx is running (needed for verification)
echo -e "${BLUE}🐳 Ensuring Docker containers are running...${NC}"
cd /var/www/maadihousing

# Use temporary nginx config for initial certificate generation
if [ -f "nginx/nginx-ssl-init.conf" ]; then
    echo -e "${BLUE}📝 Using temporary nginx config for certificate generation...${NC}"
    cp nginx/nginx.conf nginx/nginx.conf.backup
    cp nginx/nginx-ssl-init.conf nginx/nginx.conf
fi

docker-compose up -d nginx

# Wait for nginx to be ready
sleep 5

# Check if domain is pointing to this server
echo -e "${YELLOW}⚠️  IMPORTANT: Make sure ${DOMAIN} DNS points to this server's IP${NC}"
echo -e "${YELLOW}   Run: dig ${DOMAIN} +short${NC}"
echo ""
read -p "Press Enter to continue after verifying DNS..."

# Get SSL certificate
echo -e "${BLUE}🔐 Requesting SSL certificate from Let's Encrypt...${NC}"
certbot certonly \
    --webroot \
    --webroot-path=/var/www/certbot \
    --email ${EMAIL} \
    --agree-tos \
    --no-eff-email \
    --force-renewal \
    -d ${DOMAIN} \
    -d www.${DOMAIN}

# Set up auto-renewal
echo -e "${BLUE}🔄 Setting up auto-renewal...${NC}"
cat > /etc/cron.d/certbot-renew << EOF
0 0 * * * certbot renew --quiet --deploy-hook "cd /var/www/maadihousing && docker-compose restart nginx"
EOF

# Restore full nginx config with SSL
if [ -f "nginx/nginx.conf.backup" ]; then
    echo -e "${BLUE}📝 Restoring full nginx config with SSL...${NC}"
    mv nginx/nginx.conf.backup nginx/nginx.conf
fi

# Restart nginx to load SSL certificates
echo -e "${BLUE}🔄 Restarting nginx with SSL configuration...${NC}"
cd /var/www/maadihousing
docker-compose restart nginx

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✅ SSL SETUP COMPLETE!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${GREEN}🌐 Your site is now available at:${NC}"
echo -e "${GREEN}   https://${DOMAIN}${NC}"
echo -e "${GREEN}   https://www.${DOMAIN}${NC}"
echo ""
echo -e "${BLUE}📋 Certificates will auto-renew every 90 days${NC}"
echo -e "${BLUE}   Check renewal: certbot certificates${NC}"
echo ""
echo -e "${YELLOW}⚠️  If you see SSL errors, wait a few minutes for DNS propagation${NC}"
echo ""

