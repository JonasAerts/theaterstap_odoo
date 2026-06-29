#dirname!/bin/bash

# Configuration
MAIN_REPO="git@github.com:JonasAerts/TheaterStap_odoo.git"
ADDONS_REPO="git@github.com:JonasAerts/theaterstap_odoo_addons.git"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "--- Starting Deployment Pipeline ---"

# Navigate to project directory
cd $PROJECT_DIR || { echo "Directory $PROJECT_DIR not found"; exit 1; }

# Ensure local data directories exist (created as the current user to avoid permission issues)
mkdir -p odoo-web-data odoo-db-data

# Update main repository
echo "Updating main repository..."
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
git pull origin "$CURRENT_BRANCH"

# Update or Clone addons repository
if [ -d "addons/.git" ]; then
    echo "Updating addons repository..."
    cd addons
    ADDONS_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    git pull origin "$ADDONS_BRANCH"
    cd ..
else
    echo "Cloning addons repository..."
    rm -rf addons
    git clone --progress $ADDONS_REPO addons
fi

# Build and Restart Docker Containers
echo "Rebuilding and restarting Docker containers..."
BUILDKIT_PROGRESS=plain docker-compose up -d --build

# Clean up unused images to save space on NAS
echo "Cleaning up unused Docker images..."
docker image prune -f

echo "--- Deployment Complete ---"
echo "Odoo should be available at http://localhost:8069"
