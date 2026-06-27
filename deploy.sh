#dirname!/bin/bash

# Configuration
MAIN_REPO="git@github.com:JonasAerts/TheaterStap_odoo.git"
ADDONS_REPO="git@github.com:JonasAerts/theaterstap_odoo_addons.git"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "--- Starting Deployment Pipeline ---"

# Navigate to project directory
cd $PROJECT_DIR || { echo "Directory $PROJECT_DIR not found"; exit 1; }

# Update main repository
echo "Updating main repository..."
git pull origin main

# Update or Clone addons repository
if [ -d "addons/.git" ]; then
    echo "Updating addons repository..."
    cd addons
    git pull origin main
    cd ..
else
    echo "Cloning addons repository..."
    rm -rf addons
    git clone $ADDONS_REPO addons
fi

# Build and Restart Docker Containers
echo "Rebuilding and restarting Docker containers..."
docker-compose up -d --build

# Clean up unused images to save space on NAS
echo "Cleaning up unused Docker images..."
docker image prune -f

echo "--- Deployment Complete ---"
echo "Odoo should be available at http://localhost:8069"
