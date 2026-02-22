# Fix maadihousing.com Not Working (Port 80 Conflict)

## Why the domain doesn't work

- **here-home** is using **port 80** and **443** (its nginx).
- **maadihousing** also tried to use 80/443, so its **nginx never started** (port conflict).
- Hostinger shows only **3 containers** for maadihousing (backend, db, frontend) — **no nginx**.
- So when you open maadihousing.com, the server answers with **here-home**, not Maadi Housing.

## What we changed

- Maadi Housing nginx now uses **8080** and **8443** so it can run next to here-home.
- You need to route **maadihousing.com** to port **8080** (via here-home nginx or Hostinger).

---

## Step 1: Start Maadi Housing nginx (on 8080)

On your server:

```bash
cd /var/www/maadihousing
git pull
docker-compose up -d --build
docker-compose ps
```

You should see **4** containers including **maadihousing-nginx**, and port **8080** in PORTS.

Check the site on port 8080:

```bash
curl -I http://31.97.47.67:8080
```

You should get a 200 and see your Maadi Housing page.

---

## Step 2: Route maadihousing.com to port 8080

You have two options.

### Option A: Use here-home nginx (recommended)

Add a server block in **here-home’s nginx** so **maadihousing.com** is proxied to `http://127.0.0.1:8080`.

1. Find here-home’s nginx config, for example:
   ```bash
   cd /var/www/Here-Home   # or wherever here-home lives
   ls
   # look for nginx/ or similar
   ```

2. Edit the main nginx config (e.g. `nginx/nginx.conf` or `nginx/conf.d/default.conf`).

3. Add this **server** block (e.g. in `conf.d/` as `maadihousing.conf` or inside the main config):

```nginx
# Maadi Housing - route maadihousing.com to localhost:8080
server {
    listen 80;
    server_name maadihousing.com www.maadihousing.com;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

4. Reload nginx:
   ```bash
   docker-compose exec nginx nginx -t
   docker-compose exec nginx nginx -s reload
   ```
   (Use the exact service name from here-home’s `docker-compose.yml` if different.)

After this, **http://maadihousing.com** should show the Maadi Housing coming soon page.

### Option B: Hostinger reverse proxy / domain

If Hostinger has a “Websites” or “Domains” or “Reverse proxy” option:

1. Add/attach **maadihousing.com** to this VPS.
2. Set the target to **http://127.0.0.1:8080** (or “port 8080” in their UI).

Then **http://maadihousing.com** will go to Maadi Housing.

---

## Step 3: HTTPS (optional)

- For **SSL on maadihousing.com**, either:
  - Use Hostinger’s SSL/HTTPS for the domain and point it at the same reverse proxy (port 8080), or
  - Use the existing `setup-ssl.sh` flow but with a **single** nginx (here-home) that handles both domains and SSL; then maadihousing’s nginx can stay HTTP-only on 8080.

---

## Quick checklist

- [ ] `cd /var/www/maadihousing` → `git pull` → `docker-compose up -d --build`
- [ ] `docker-compose ps` shows **maadihousing-nginx** and **8080**
- [ ] `curl -I http://31.97.47.67:8080` returns 200
- [ ] Add server block for maadihousing.com → `127.0.0.1:8080` in here-home nginx (or Hostinger)
- [ ] Reload nginx (or save Hostinger config)
- [ ] Open **http://maadihousing.com** in browser

After Step 1 and Step 2, the domain name will work.
