# Maadi Housing - Standalone SSL Setup

Maadi Housing is a **standalone project** with its own nginx on ports **80** and **443**.

## What You Get

- **HTTP:** `http://maadihousing.com` – works out of the box
- **HTTPS:** `https://maadihousing.com` – works with **self-signed cert** (browser will show "Not secure" until you run setup-ssl.sh for Let's Encrypt)

## Quick Start (Server)

```bash
cd /var/www/maadihousing
git pull
docker-compose down
docker-compose up -d --build
docker-compose ps
```

Nginx starts with a self-signed cert so both HTTP and HTTPS work. The browser will warn about the cert until you install Let's Encrypt.

## Get Let's Encrypt Cert (Production)

1. Ensure DNS for `maadihousing.com` points to your server
2. Run:

```bash
cd /var/www/maadihousing
chmod +x setup-ssl.sh
sudo ./setup-ssl.sh
```

That fetches Let's Encrypt certs and updates nginx. After reload, the browser will show a valid lock.

## Port Conflicts

Maadi Housing uses **80** and **443**. If another project (e.g. here-home) is using those ports on the same server:

- Use a **different server** for maadihousing, or
- Change nginx ports in `docker-compose.yml` (e.g. `8080:80` and `8443:443`) and put a separate reverse proxy in front that routes maadihousing.com to that port
