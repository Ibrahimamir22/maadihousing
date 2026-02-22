# Debug: Subscription form "Unable to connect"

Run these on the server (`cd /var/www/maadihousing`) to find where the request fails.

## 1. Check all containers are running

```bash
docker compose ps
```

All 4 (db, backend, frontend, nginx) should show "Up".

## 2. Test API from inside the stack

```bash
docker compose exec nginx curl -s -o /dev/null -w "%{http_code}" -X POST http://backend:8000/api/subscribe/ \
  -H "Content-Type: application/json" -d '{"email":"test@example.com"}'
```

- `201` = backend OK
- `502`/`000` = backend unreachable (check `docker compose logs backend`)

## 3. Test API from host (via Traefik)

```bash
curl -s -o /dev/null -w "%{http_code}" --resolve maadihousing.com:443:127.0.0.1 -k \
  -X POST https://maadihousing.com/api/subscribe/ \
  -H "Content-Type: application/json" -d '{"email":"test@example.com"}'
```

- `201` = full path OK
- `502` = Traefik can't reach maadihousing-nginx (Traefik must be on maadihousing network)
- `000` / connection refused = Traefik not routing maadihousing.com

## 4. Check Traefik can reach maadihousing-nginx

Traefik must be attached to the maadihousing network to resolve `maadihousing-nginx`.
In your Traefik compose, ensure something like:

```yaml
networks:
  maadihousing:
    external: true
```

And the Traefik service is connected to that network.
