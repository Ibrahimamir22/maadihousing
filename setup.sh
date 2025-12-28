#!/bin/bash

# Maadi Housing - Quick Setup Script
# This script sets up both frontend and backend for development

set -e

echo "🏠 Setting up Maadi Housing..."
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Setup Frontend
echo "📦 Installing frontend dependencies..."
cd frontend
npm install
cd ..
echo -e "${GREEN}✓ Frontend dependencies installed${NC}"
echo ""

# Setup Backend
echo "🐍 Setting up backend..."
cd backend

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install dependencies
echo "Installing Python dependencies..."
pip install -r requirements.txt

# Run migrations
echo "Running database migrations..."
python manage.py migrate

# Create superuser
echo "Creating admin superuser..."
python manage.py setup_admin

cd ..
echo -e "${GREEN}✓ Backend setup complete${NC}"
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}🎉 Setup complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "To start development servers:"
echo ""
echo -e "${YELLOW}Terminal 1 (Frontend):${NC}"
echo "  cd frontend && npm run dev"
echo ""
echo -e "${YELLOW}Terminal 2 (Backend):${NC}"
echo "  cd backend && source venv/bin/activate && python manage.py runserver"
echo ""
echo "Access:"
echo "  - Frontend: http://localhost:3000"
echo "  - Backend:  http://localhost:8000"
echo "  - Admin:    http://localhost:8000/admin/"
echo ""
echo "Admin credentials:"
echo "  - Username: maadihousing"
echo "  - Password: maadihousing"
echo ""

