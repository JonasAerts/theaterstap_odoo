#! /usr/bin/env bash
CONTAINER_NAME=$1
DATABASE_NAME=$2

if [ -z $CONTAINER_NAME ]
then
  echo "Usage: $0 [container name] [database name]"
  exit 1
fi

if [ -z $DATABASE_NAME ]
then
  echo "Usage: $0 [container name] [database name]"
  exit 1
fi

# Set bash to exit if any further command fails
set -e
set -o pipefail

# Create a file name for the backup based on the current date and time
# Example: 2026-06-29_23:55:00.odoo.dump
FILE_NAME=$(date +%Y-%m-%d_%H-%M-%S.$DATABASE_NAME.dump)

# Make sure the backups folder exists on the host file system
mkdir -p "./backups"

echo "Backing up database '$DATABASE_NAME' from container '$CONTAINER_NAME'..."

# Create a database backup with pg_dump and stream it directly to the host file
# Note: We do NOT use the -t (TTY) flag on docker exec to avoid binary corruption
docker exec -e PGPASSWORD="odoo" "$CONTAINER_NAME" pg_dump -U odoo -F c "$DATABASE_NAME" > "./backups/$FILE_NAME"

echo "Backed up database '$DATABASE_NAME' to ./backups/$FILE_NAME"
echo "Done!"
