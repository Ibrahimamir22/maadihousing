# 🔒 SSL Setup Guide for Maadi Housing

## ⚠️ Current Issue
Your site is trying to use HTTPS but SSL certificates aren't configured yet.

## 🚀 Quick Fix Options

### Option 1: Use HTTP Temporarily (Fastest)

**On your server, run:**

```bash
cd /var/www/maadihousing

# Edit nginx config to temporarily disable SSL requirement
# Comment out the HTTPS redirect temporarily
nano nginx/nginx.conf

# Find this section and comment it out:
# location / {
#     return 301 https://$host$request_uri;
# }

# Restart nginx
docker-compose restart nginx
```

**Then access:** `http://maadihousing.com` (note: HTTP, not HTTPS)

---

### Option 2: Set Up SSL Properly (Recommended)

**Prerequisites:**
1. ✅ Domain `maadihousing.com` DNS must point to your server IP
2. ✅ Ports 80 and 443 must be open in firewall
3. ✅ Docker containers must be running

**Steps:**

```bash
# 1. Verify DNS is pointing to your server
dig maadihousing.com +short
# Should show your server's IP address

# 2. Run SSL setup script
cd /var/www/maadihousing
chmod +x setup-ssl.sh
sudo ./setup-ssl.sh

# 3. Follow the prompts
# - Enter email: info@maadihousing.com
# - Agree to terms
# - Wait for certificate generation

# 4. Access your site
# https://maadihousing.com
```

---

## 🔧 Manual SSL Setup (If script doesn't work)

```bash
# 1. Install certbot
sudo apt update
sudo apt install -y certbot python3-certbot-nginx

# 2. Create certbot directories
sudo mkdir -p /var/www/certbot
sudo mkdir -p /etc/letsencrypt

# 3. Make sure nginx is running
cd /var/www/maadihousing
docker-compose up -d nginx

# 4. Get certificate
sudo certbot certonly \
    --webroot \
    --webroot-path=/var/www/certbot \
    --email info@maadihousing.com \
    --agree-tos \
    --no-eff-email \
    -d maadihousing.com \
    -d www.maadihousing.com

# 5. Restart nginx
docker-compose restart nginx
```

---

## ✅ Verify SSL Setup

```bash
# Check certificates
sudo certbot certificates

# Test SSL
curl -I https://maadihousing.com

# Check nginx logs
docker-compose logs nginx
```

---

## 🔄 Auto-Renewal Setup

Certificates expire every 90 days. Set up auto-renewal:

```bash
# Add to crontab
sudo crontab -e

# Add this line:
0 0 * * * certbot renew --quiet --deploy-hook "cd /var/www/maadihousing && docker-compose restart nginx"
```

---

## 🐛 Troubleshooting

### Error: "Domain not pointing to this server"
- Check DNS: `dig maadihousing.com +short`
- Wait for DNS propagation (can take up to 48 hours)
- Make sure A record points to your server IP

### Error: "Port 80 already in use"
```bash
# Check what's using port 80
sudo netstat -tulpn | grep :80

# Stop conflicting service or change nginx port
```

### Error: "Connection refused"
```bash
# Check firewall
sudo ufw status
sudo ufw allow 80
sudo ufw allow 443

# Check nginx is running
docker-compose ps
```

### SSL still not working after setup
```bash
# Check certificate files exist
sudo ls -la /etc/letsencrypt/live/maadihousing.com/

# Verify nginx config
docker-compose exec nginx nginx -t

# Check logs
docker-compose logs nginx | grep -i ssl
```

---

## 📋 Quick Reference

**Access URLs:**
- HTTP: `http://maadihousing.com`
- HTTPS: `https://maadihousing.com`
- Admin: `https://maadihousing.com/admin/`

**Useful Commands:**
```bash
# Restart nginx
docker-compose restart nginx

# View nginx logs
docker-compose logs -f nginx

# Test nginx config
docker-compose exec nginx nginx -t

# Renew certificate manually
sudo certbot renew
```

---

## 🎯 Recommended: Use HTTP First, Then SSL

1. **Immediate fix:** Access via HTTP (`http://maadihousing.com`)
2. **Set up SSL:** Run `setup-ssl.sh` when DNS is ready
3. **Switch to HTTPS:** After SSL is configured, site will auto-redirect

**Your site works perfectly on HTTP - SSL is just for security!** 🔒

