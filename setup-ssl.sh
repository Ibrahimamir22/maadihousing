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

# Make sure maadihousing is running (nginx serves .well-known for certbot)
echo -e "${BLUE}🐳 Ensuring Maadi Housing is running...${NC}"
cd /var/www/maadihousing
docker-compose up -d

# Wait for nginx
sleep 5

# Check if domain is pointing to this server
echo -e "${YELLOW}⚠️  IMPORTANT: Make sure ${DOMAIN} DNS points to this server's IP${NC}"
echo -e "${YELLOW}   Run: dig ${DOMAIN} +short${NC}"
echo ""
read -p "Press Enter to continue after verifying DNS..."

# Get SSL certificate (uses same volumes as nginx so certs are shared)
echo -e "${BLUE}🔐 Requesting SSL certificate from Let's Encrypt...${NC}"
docker run --rm \
  -v maadihousing_certbot-www:/var/www/certbot \
  -v maadihousing_certbot-conf:/etc/letsencrypt \
  certbot/certbot certonly \
  --webroot -w /var/www/certbot \
  --email ${EMAIL} \
  --agree-tos \
  --no-eff-email \
  -d ${DOMAIN} \
  -d www.${DOMAIN}

# Set up auto-renewal
echo -e "${BLUE}🔄 Setting up auto-renewal...${NC}"
cat > /etc/cron.d/certbot-maadihousing << EOF
0 0 * * * root docker run --rm -v maadihousing_certbot-conf:/etc/letsencrypt -v maadihousing_certbot-www:/var/www/certbot certbot/certbot renew --quiet --deploy-hook "cd /var/www/maadihousing && docker-compose restart nginx"
EOF

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

