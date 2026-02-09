#!/bin/bash

# Startup script for Render deployment
# This script runs database migrations before starting the server

echo "Starting EquipSense Backend..."

# Run database migrations
echo "Running database migrations..."
python manage.py migrate --noinput

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput

# Create superuser if needed (optional - for first-time setup)
# Uncomment and set environment variables if needed:
# if [ "$DJANGO_SUPERUSER_USERNAME" ]; then
#     python manage.py createsuperuser --noinput \
#         --username $DJANGO_SUPERUSER_USERNAME \
#         --email $DJANGO_SUPERUSER_EMAIL
# fi

echo "Starting Gunicorn server..."
exec gunicorn equipment_backend.wsgi:application \
    --bind 0.0.0.0:${PORT:-8000} \
    --workers 2 \
    --threads 4 \
    --timeout 60 \
    --access-logfile - \
    --error-logfile - \
    --log-level info
