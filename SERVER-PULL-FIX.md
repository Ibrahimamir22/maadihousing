# Server: Fix "port 80 already allocated" and git pull conflict

## What’s wrong

- **git pull** failed because the server has **local changes** to `docker-compose.yml`, so it never got the update that uses ports **8080** and **8443**.
- So the server still uses **80:80** and nginx fails with “port is already allocated”.

## Fix on the server (run these in order)

```bash
cd /var/www/maadihousing

# 1. Drop local changes so pull can apply (repo has the fixes)
git checkout -- docker-compose.yml
git checkout -- nginx/nginx.conf

# 2. Pull latest (nginx fix stops restart loop; 8080/8443 for port conflict)
git pull

# 3. Restart with correct ports
docker-compose down
docker-compose up -d --build

# 4. Check (nginx should show 8080->80, 8443->443)
docker-compose ps
```

After this, you should see **4** containers and **maadihousing-nginx** with ports **8080** and **8443**.

## If you prefer to keep local edits

If you changed `docker-compose.yml` on purpose, edit it manually instead of `git checkout`:

```bash
nano docker-compose.yml
```

Under the **nginx** service, set:

```yaml
    ports:
      - "8080:80"
      - "8443:443"
```

Save, then run `docker-compose down` and `docker-compose up -d --build`.
