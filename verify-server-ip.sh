#!/bin/bash

# Maadi Housing - Server IP Verification Script
# This helps determine which IP is actually your server

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

DETECTED_IP="31.97.47.67"
DNS_IP="84.32.84.32"

echo -e "${BLUE}🔍 Verifying which IP is your actual server${NC}"
echo "=========================================="
echo ""

# Test 1: Check which IP responds with your site
echo -e "${BLUE}📡 Test 1: Checking which IP serves your site...${NC}"
echo ""

echo -e "${YELLOW}Testing ${DETECTED_IP}...${NC}"
RESPONSE1=$(curl -s -I -m 5 "http://${DETECTED_IP}" 2>&1 | head -1 || echo "FAILED")
if echo "$RESPONSE1" | grep -q "HTTP"; then
    echo -e "${GREEN}✅ ${DETECTED_IP} responds: ${RESPONSE1}${NC}"
    if echo "$RESPONSE1" | grep -q "200\|301\|302"; then
        echo -e "${GREEN}   → This IP serves your Maadi Housing site!${NC}"
        DETECTED_WORKS=true
    fi
else
    echo -e "${RED}❌ ${DETECTED_IP} failed or timeout${NC}"
    DETECTED_WORKS=false
fi

echo ""
echo -e "${YELLOW}Testing ${DNS_IP}...${NC}"
RESPONSE2=$(curl -s -I -m 5 "http://${DNS_IP}" 2>&1 | head -1 || echo "FAILED")
if echo "$RESPONSE2" | grep -q "HTTP"; then
    echo -e "${GREEN}✅ ${DNS_IP} responds: ${RESPONSE2}${NC}"
    if echo "$RESPONSE2" | grep -q "200\|301\|302"; then
        echo -e "${GREEN}   → This IP serves your Maadi Housing site!${NC}"
        DNS_WORKS=true
    fi
else
    echo -e "${RED}❌ ${DNS_IP} failed or timeout${NC}"
    DNS_WORKS=false
fi

echo ""

# Test 2: Check server hostname
echo -e "${BLUE}📡 Test 2: Checking server hostname...${NC}"
HOSTNAME_IP=$(hostname -I | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' | grep -v '127.0.0.1' | head -1)
echo -e "${GREEN}Server hostname IPs: $(hostname -I)${NC}"
echo ""

# Test 3: Check which IP is in network interfaces
echo -e "${BLUE}📡 Test 3: Checking network interfaces...${NC}"
ALL_IPS=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1')
echo -e "${GREEN}All server IPs:${NC}"
for ip in $ALL_IPS; do
    if [ "$ip" == "$DETECTED_IP" ]; then
        echo -e "${GREEN}   ✅ ${ip} (detected as public IP)${NC}"
    elif [ "$ip" == "$DNS_IP" ]; then
        echo -e "${GREEN}   ✅ ${ip} (DNS points here)${NC}"
    else
        echo -e "${BLUE}   ${ip}${NC}"
    fi
done
echo ""

# Test 4: Check which IP the domain actually resolves to from server
echo -e "${BLUE}📡 Test 4: What does maadihousing.com resolve to from this server?${NC}"
DOMAIN_RESOLVE=$(dig +short maadihousing.com @8.8.8.8 | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | head -1)
echo -e "${GREEN}Domain resolves to: ${DOMAIN_RESOLVE}${NC}"
echo ""

# Summary
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}📋 VERIFICATION SUMMARY${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

if [ "$DNS_IP" == "$DOMAIN_RESOLVE" ]; then
    echo -e "${GREEN}✅ DNS is correctly configured!${NC}"
    echo -e "${GREEN}   Domain points to: ${DNS_IP}${NC}"
    echo ""
    
    if [ "$DNS_WORKS" = true ]; then
        echo -e "${GREEN}✅ ${DNS_IP} serves your site correctly${NC}"
        echo ""
        echo -e "${GREEN}🚀 DNS IS READY FOR SSL!${NC}"
        echo ""
        echo -e "${GREEN}You can now run:${NC}"
        echo -e "${GREEN}   sudo ./setup-ssl.sh${NC}"
    else
        echo -e "${YELLOW}⚠️  ${DNS_IP} doesn't serve your site${NC}"
        echo -e "${YELLOW}   This might be a CDN/proxy IP${NC}"
        echo ""
        echo -e "${YELLOW}💡 Recommendation: Update DNS to point to ${DETECTED_IP}${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  DNS needs to be updated${NC}"
    echo ""
    echo -e "${YELLOW}Current DNS: ${DNS_IP}${NC}"
    echo -e "${YELLOW}Should point to: ${DETECTED_IP}${NC}"
    echo ""
    echo -e "${YELLOW}📝 Update DNS A record to: ${DETECTED_IP}${NC}"
fi

echo ""

