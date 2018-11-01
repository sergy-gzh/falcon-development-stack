#!/usr/bin/env bash

set -e
echo "sleeping"
sleep 20 ## just a test, seems like the DB needs to spin up

echo "installing wp"
wp --allow-root core install --url="${WORDPRESS_URL}" --title="${WORDPRESS_TITLE}"  --admin_user="${WORDPRESS_ADMIN_USERNAME}"  --admin_email="${WORDPRESS_ADMIN_EMAIL}"  --admin_password="${WORDPRESS_ADMIN_PASSWORD}"   --path='/var/www/html'

echo "setting permalink_structure"
wp --allow-root option update permalink_structure '/%postname%/'

echo "activeing deity plugin"
wp --allow-root plugin activate  deity-wordpress-api 
