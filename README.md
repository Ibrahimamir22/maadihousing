# Maadi Housing - Coming Soon Page

A beautiful, modern coming soon landing page for **maadihousing.com** with email subscription functionality.

## Tech Stack

- **Frontend**: Next.js 15 (App Router), React 19, TypeScript, Tailwind CSS
- **Backend**: Django 5.1, Django REST Framework
- **Database**: PostgreSQL 17
- **Server**: Nginx (reverse proxy)
- **Containerization**: Docker & Docker Compose
- **Node.js**: 22 LTS
- **Python**: 3.13

## Project Structure

```
maadihousing/
├── frontend/              # Next.js frontend application
│   ├── src/
│   │   ├── app/          # App router pages
│   │   └── components/   # React components
│   ├── Dockerfile
│   └── package.json
├── backend/               # Django backend application
│   ├── config/           # Django settings
│   ├── subscribers/      # Email subscription app
│   ├── Dockerfile
│   └── requirements.txt
├── nginx/                 # Nginx configuration
│   ├── nginx.conf
│   └── Dockerfile
├── docker-compose.yml     # Production compose file
├── docker-compose.dev.yml # Development override
└── README.md
```

## Quick Start

### Prerequisites

- Docker & Docker Compose installed
- Git

## 🚀 Production Deployment

### Server Setup (One-time)

```bash
# On your server (run as root/sudo)
wget https://raw.githubusercontent.com/Ibrahimamir22/maadihousing/main/server-setup.sh
chmod +x server-setup.sh
./server-setup.sh
```

### Deploy Application

```bash
# Upload project to server
cd /var/www/maadihousing
git clone https://github.com/Ibrahimamir22/maadihousing.git .

# Or upload via SCP from local machine:
# scp -r /path/to/local/maadihousing/* root@server-ip:/var/www/maadihousing/

# Deploy
chmod +x deploy.sh
./deploy.sh
```

### Access Your Site

- **Frontend:** `http://your-server-ip`
- **Admin:** `http://your-server-ip/admin/`
- **API:** `http://your-server-ip/api/`

**Admin Credentials:**
- Username: `maadihousing`
- Password: `maadihousing`
- Email: `info@maadihousing.com`

## 🔧 Management Commands

```bash
# View logs
docker-compose logs -f

# Restart services
docker-compose restart

# Update application
git pull && docker-compose up -d --build

# Backup database
docker-compose exec db pg_dump -U postgres maadihousing > backup_$(date +%Y%m%d).sql

# Access Django shell
docker-compose exec backend python manage.py shell
```

## 🛠️ Environment Configuration

The `.env` file contains all necessary configuration. Key variables:

```env
# Database
POSTGRES_PASSWORD=your-secure-password

# Django
DJANGO_SECRET_KEY=your-unique-secret-key
DEBUG=False

# Domains (update for production)
ALLOWED_HOSTS=yourdomain.com,www.yourdomain.com
CORS_ALLOWED_ORIGINS=https://yourdomain.com,https://www.yourdomain.com
NEXT_PUBLIC_API_URL=https://yourdomain.com/api
```

### Development Setup

1. **Clone the repository**
   ```bash
   cd maadihousing
   ```

2. **Create environment file**
   ```bash
   cp env.example .env
   # Edit .env with your values
   ```

3. **Run with Docker Compose (Development)**
   ```bash
   # Start all services in development mode
   docker-compose -f docker-compose.yml -f docker-compose.dev.yml up --build
   ```

4. **Run database migrations**
   ```bash
   docker-compose exec backend python manage.py migrate
   ```

5. **Create admin superuser (optional)**
   ```bash
   docker-compose exec backend python manage.py createsuperuser
   ```

6. **Access the application**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:8000
   - Django Admin: http://localhost:8000/admin/

### Production Deployment

1. **Create production environment file**
   ```bash
   cp env.example .env
   # Edit .env with secure production values
   ```

2. **Build and start services**
   ```bash
   docker-compose up -d --build
   ```

3. **Run migrations**
   ```bash
   docker-compose exec backend python manage.py migrate
   ```

4. **Access the application**
   - Site: http://localhost (or your domain)
   - Django Admin: http://localhost/admin/

## Local Development (Without Docker)

### Frontend

```bash
cd frontend
npm install
npm run dev
```

### Backend

```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/subscribe/` | Subscribe email to launch notifications |
| GET | `/health/` | Health check endpoint |

### Subscribe Request Example

```bash
curl -X POST http://localhost:8000/api/subscribe/ \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com"}'
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `POSTGRES_PASSWORD` | PostgreSQL password | postgres |
| `DJANGO_SECRET_KEY` | Django secret key | (insecure default) |
| `DEBUG` | Django debug mode | True |
| `NEXT_PUBLIC_API_URL` | API URL for frontend | http://localhost:8000 |

## Features

- 🎨 Beautiful, unique dark-themed design
- ⏱️ Animated countdown timer
- 📧 Email subscription with rate limiting
- 📱 Fully responsive design
- 🔒 Security headers via Nginx
- 🐳 Docker containerization
- ⚡ Optimized production builds

## Customization

### Change Launch Date

Edit the `launchDate` in `frontend/src/app/page.tsx`:

```typescript
const launchDate = new Date('2025-03-01T00:00:00')
```

### Update Social Links

Edit `frontend/src/components/social-links.tsx` to update your social media URLs.

### Modify Colors

Update the color palette in `frontend/tailwind.config.ts`:

```typescript
colors: {
  brand: {
    midnight: '#0a0a0f',
    copper: '#c17f59',
    gold: '#d4a574',
    // ...
  }
}
```

## License

© 2025 Maadi Housing. All rights reserved.

