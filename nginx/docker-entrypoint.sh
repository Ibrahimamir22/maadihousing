#!/bin/sh
# Create self-signed cert if Let's Encrypt certs don't exist (so nginx can start)
CERT_DIR="/etc/letsencrypt/live/maadihousing.com"
if [ ! -f "$CERT_DIR/fullchain.pem" ]; then
  mkdir -p "$CERT_DIR"
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "$CERT_DIR/privkey.pem" \
    -out "$CERT_DIR/fullchain.pem" \
    -subj "/CN=maadihousing.com" 2>/dev/null
fi
exec nginx -g "daemon off;"
