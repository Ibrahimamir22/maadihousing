#!/bin/bash

# Add useful Docker aliases to ~/.bashrc

ALIASES='
# Maadi Housing Docker Aliases
alias mh-ps="cd /var/www/maadihousing && docker-compose ps"
alias mh-logs="cd /var/www/maadihousing && docker-compose logs -f"
alias mh-restart="cd /var/www/maadihousing && docker-compose restart"
alias mh-stop="cd /var/www/maadihousing && docker-compose stop"
alias mh-start="cd /var/www/maadihousing && docker-compose up -d"
alias mh-down="cd /var/www/maadihousing && docker-compose down"
alias mh-up="cd /var/www/maadihousing && docker-compose up -d --build"
alias mh-shell-backend="cd /var/www/maadihousing && docker-compose exec backend bash"
alias mh-shell-db="cd /var/www/maadihousing && docker-compose exec db psql -U postgres maadihousing"
'

echo "Adding aliases to ~/.bashrc..."
echo "$ALIASES" >> ~/.bashrc

echo ""
echo "✅ Aliases added! Run 'source ~/.bashrc' or restart your terminal"
echo ""
echo "Now you can use:"
echo "  mh-ps        - View Maadi Housing containers"
echo "  mh-logs      - View logs"
echo "  mh-restart   - Restart services"
echo "  mh-stop      - Stop services"
echo "  mh-start     - Start services"
echo "  mh-up        - Rebuild and start"
echo ""
