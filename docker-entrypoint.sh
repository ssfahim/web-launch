#!/bin/bash

# Fix permissions
chown -R www-data:www-data /var/www/html
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Run the original CMD
exec "$@"
