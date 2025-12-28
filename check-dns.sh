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

# Get server's public IP (IPv4 specifically)
echo -e "${BLUE}📡 Getting server's public IP (IPv4)...${NC}"
SERVER_IP=$(curl -4 -s ifconfig.me 2>/dev/null || curl -4 -s ipinfo.io/ip 2>/dev/null || curl -4 -s icanhazip.com 2>/dev/null || curl -s https://api.ipify.org 2>/dev/null)

# If still no IPv4, try getting from network interface
if [ -z "$SERVER_IP" ] || [[ "$SERVER_IP" == *":"* ]]; then
    SERVER_IP=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | head -1)
fi

if [ -z "$SERVER_IP" ]; then
    echo -e "${RED}❌ Could not determine server IPv4 address${NC}"
    echo -e "${YELLOW}   Please check your server's network configuration${NC}"
    exit 1
fi

echo -e "${GREEN}Your server IPv4: ${SERVER_IP}${NC}"

# Also show IPv6 if available
SERVER_IPV6=$(curl -6 -s ifconfig.me 2>/dev/null || ip -6 addr show | grep -oP '(?<=inet6\s)[0-9a-f:]+' | grep -v '::1' | head -1)
if [ -n "$SERVER_IPV6" ]; then
    echo -e "${GREEN}Your server IPv6: ${SERVER_IPV6}${NC}"
fi

# Show all network interfaces
echo -e "${BLUE}📡 All server IP addresses:${NC}"
ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | while read ip; do
    echo -e "   ${GREEN}${ip}${NC}"
done
echo ""

# Check DNS A record
echo -e "${BLUE}🌐 Checking DNS A record for ${DOMAIN}...${NC}"
DNS_IP=$(dig +short ${DOMAIN} | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | head -1)

if [ -z "$DNS_IP" ]; then
    echo -e "${RED}❌ No A record found for ${DOMAIN}${NC}"
    echo -e "${YELLOW}   DNS might not be configured yet${NC}"
    DNS_READY=false
else
    echo -e "${GREEN}DNS A record points to: ${DNS_IP}${NC}"
    
    # Check if DNS IP matches primary server IP
    if [ "$DNS_IP" == "$SERVER_IP" ]; then
        echo -e "${GREEN}✅ DNS is correctly pointing to your server!${NC}"
        DNS_READY=true
    else
        # Check if DNS IP is one of the server's IP addresses
        SERVER_IPS=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1')
        if echo "$SERVER_IPS" | grep -q "^${DNS_IP}$"; then
            echo -e "${GREEN}✅ DNS points to one of your server's IP addresses!${NC}"
            echo -e "${GREEN}   (Server has multiple IPs, DNS is using: ${DNS_IP})${NC}"
            DNS_READY=true
            SERVER_IP="$DNS_IP"  # Update to use the DNS IP for SSL setup
        else
            echo -e "${YELLOW}⚠️  DNS points to different IP: ${DNS_IP}${NC}"
            echo -e "${YELLOW}   Expected one of: ${SERVER_IP}${NC}"
            echo -e "${YELLOW}   Found: ${DNS_IP}${NC}"
            echo -e "${BLUE}   💡 If ${DNS_IP} is your server's IP, update DNS to point to it${NC}"
            DNS_READY=false
        fi
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
    echo -e "${GREEN}✅ Port 80 is open and accessible on ${SERVER_IP}${NC}"
else
    echo -e "${YELLOW}⚠️  Port 80 might be blocked or not accessible${NC}"
    echo -e "${YELLOW}   Check firewall: sudo ufw status${NC}"
fi

# If DNS IP is different, check if that IP is reachable
if [ -n "$DNS_IP" ] && [ "$DNS_IP" != "$SERVER_IP" ]; then
    echo -e "${BLUE}🔌 Checking if DNS IP ${DNS_IP} is reachable...${NC}"
    if timeout 3 bash -c "echo > /dev/tcp/${DNS_IP}/80" 2>/dev/null; then
        echo -e "${GREEN}✅ Port 80 is accessible on DNS IP ${DNS_IP}${NC}"
        echo -e "${BLUE}   💡 This might be your actual server IP!${NC}"
    else
        echo -e "${YELLOW}⚠️  DNS IP ${DNS_IP} port 80 not accessible${NC}"
    fi
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
    echo -e "${YELLOW}⚠️  DNS configuration check${NC}"
    echo ""
    
    if [ -n "$DNS_IP" ]; then
        echo -e "${BLUE}📋 Current DNS Status:${NC}"
        echo -e "${BLUE}   DNS points to: ${DNS_IP}${NC}"
        echo -e "${BLUE}   Detected server IP: ${SERVER_IP}${NC}"
        echo ""
        echo -e "${YELLOW}💡 Options:${NC}"
        echo -e "${YELLOW}   1. If ${DNS_IP} is correct (your server's actual IP):${NC}"
        echo -e "${YELLOW}      → DNS is ready! Run: sudo ./setup-ssl.sh${NC}"
        echo ""
        echo -e "${YELLOW}   2. If ${DNS_IP} is wrong (CDN/proxy/old IP):${NC}"
        echo -e "${YELLOW}      → Update DNS A record to: ${SERVER_IP}${NC}"
        echo ""
        echo -e "${YELLOW}📝 To update DNS:${NC}"
        echo -e "${YELLOW}   1. Go to your domain registrar${NC}"
        echo -e "${YELLOW}   2. Edit A record: ${DOMAIN} → ${SERVER_IP}${NC}"
        echo -e "${YELLOW}   3. Edit A record: www.${DOMAIN} → ${SERVER_IP}${NC}"
        echo -e "${YELLOW}   4. Wait 5-60 minutes for DNS propagation${NC}"
        echo -e "${YELLOW}   5. Run this script again: ./check-dns.sh${NC}"
    else
        echo -e "${YELLOW}📝 To configure DNS:${NC}"
        echo -e "${YELLOW}   1. Go to your domain registrar${NC}"
        echo -e "${YELLOW}   2. Add A record: ${DOMAIN} → ${SERVER_IP}${NC}"
        echo -e "${YELLOW}   3. Add A record: www.${DOMAIN} → ${SERVER_IP}${NC}"
        echo -e "${YELLOW}   4. Wait 5-60 minutes for DNS propagation${NC}"
        echo -e "${YELLOW}   5. Run this script again: ./check-dns.sh${NC}"
    fi
fi

echo ""

