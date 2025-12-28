#!/bin/bash

# Maadi Housing - DNS Check Script
# This script checks if DNS is properly configured

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

DOMAIN="maadihousing.com"

echo -e "${BLUE}🔍 Checking DNS Configuration for ${DOMAIN}${NC}"
echo "=========================================="
echo ""

# Get server's public IP
echo -e "${BLUE}📡 Getting server's public IP...${NC}"
SERVER_IP=$(curl -s ifconfig.me || curl -s ipinfo.io/ip || curl -s icanhazip.com)
echo -e "${GREEN}Your server IP: ${SERVER_IP}${NC}"
echo ""

# Check DNS A record
echo -e "${BLUE}🌐 Checking DNS A record for ${DOMAIN}...${NC}"
DNS_IP=$(dig +short ${DOMAIN} | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | head -1)

if [ -z "$DNS_IP" ]; then
    echo -e "${RED}❌ No A record found for ${DOMAIN}${NC}"
    echo -e "${YELLOW}   DNS might not be configured yet${NC}"
else
    echo -e "${GREEN}DNS A record points to: ${DNS_IP}${NC}"
    
    if [ "$DNS_IP" == "$SERVER_IP" ]; then
        echo -e "${GREEN}✅ DNS is correctly pointing to your server!${NC}"
        DNS_READY=true
    else
        echo -e "${YELLOW}⚠️  DNS points to different IP: ${DNS_IP}${NC}"
        echo -e "${YELLOW}   Expected: ${SERVER_IP}${NC}"
        echo -e "${YELLOW}   Found: ${DNS_IP}${NC}"
        DNS_READY=false
    fi
fi

echo ""

# Check www subdomain
echo -e "${BLUE}🌐 Checking DNS A record for www.${DOMAIN}...${NC}"
WWW_DNS_IP=$(dig +short www.${DOMAIN} | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | head -1)

if [ -z "$WWW_DNS_IP" ]; then
    echo -e "${YELLOW}⚠️  No A record found for www.${DOMAIN}${NC}"
else
    echo -e "${GREEN}www DNS A record points to: ${WWW_DNS_IP}${NC}"
    
    if [ "$WWW_DNS_IP" == "$SERVER_IP" ]; then
        echo -e "${GREEN}✅ www subdomain is correctly configured!${NC}"
    else
        echo -e "${YELLOW}⚠️  www points to different IP: ${WWW_DNS_IP}${NC}"
    fi
fi

echo ""

# Check if domain resolves via different DNS servers
echo -e "${BLUE}🌍 Checking DNS propagation...${NC}"
echo "Testing from multiple DNS servers:"
echo ""

DNS_SERVERS=("8.8.8.8" "1.1.1.1" "208.67.222.222")
for dns_server in "${DNS_SERVERS[@]}"; do
    resolved_ip=$(dig @${dns_server} +short ${DOMAIN} | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | head -1)
    if [ -n "$resolved_ip" ]; then
        if [ "$resolved_ip" == "$SERVER_IP" ]; then
            echo -e "${GREEN}✅ ${dns_server} (Google): ${resolved_ip} ✓${NC}"
        else
            echo -e "${YELLOW}⚠️  ${dns_server} (Google): ${resolved_ip} (different)${NC}"
        fi
    else
        echo -e "${RED}❌ ${dns_server}: No response${NC}"
    fi
done

echo ""

# Check if port 80 is accessible
echo -e "${BLUE}🔌 Checking if port 80 is accessible from outside...${NC}"
if timeout 3 bash -c "echo > /dev/tcp/${SERVER_IP}/80" 2>/dev/null; then
    echo -e "${GREEN}✅ Port 80 is open and accessible${NC}"
else
    echo -e "${YELLOW}⚠️  Port 80 might be blocked or not accessible${NC}"
    echo -e "${YELLOW}   Check firewall: sudo ufw status${NC}"
fi

echo ""

# Summary
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}📋 DNS Status Summary${NC}"
echo -e "${BLUE}========================================${NC}"

if [ "$DNS_READY" = true ]; then
    echo -e "${GREEN}✅ DNS is ready for SSL setup!${NC}"
    echo ""
    echo -e "${GREEN}🚀 You can now run:${NC}"
    echo -e "${GREEN}   sudo ./setup-ssl.sh${NC}"
else
    echo -e "${YELLOW}⚠️  DNS needs to be configured${NC}"
    echo ""
    echo -e "${YELLOW}📝 To configure DNS:${NC}"
    echo -e "${YELLOW}   1. Go to your domain registrar${NC}"
    echo -e "${YELLOW}   2. Add A record: ${DOMAIN} → ${SERVER_IP}${NC}"
    echo -e "${YELLOW}   3. Add A record: www.${DOMAIN} → ${SERVER_IP}${NC}"
    echo -e "${YELLOW}   4. Wait 5-60 minutes for DNS propagation${NC}"
    echo -e "${YELLOW}   5. Run this script again to verify${NC}"
fi

echo ""

