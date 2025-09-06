#!/bin/bash
set -e

# Get env variables from .env file if it exists
if [ -f .env ]; then
  source .env
fi

# Default output file
SQL_FILE="schemas/dump.sql"

show_help() {
  echo "Usage: $0 [--demo | --clean | --help]"
  echo
  echo "Options:"
  echo "  --clean     Export to 'clean.sql' (you can manually sanitize it afterward)"
  echo "  --demo      Export to 'demo.sql' (for generating dummy dataset backup)"
  echo "  --help      Show this help message"
  echo
  echo "If no flag is provided, the database will be exported to 'dump.sql' by default."
}

# Parse arguments
for arg in "$@"; do
  case $arg in
    --demo)
      SQL_FILE="schemas/demo.sql"
      shift
      ;;
    --clean)
      SQL_FILE="schemas/clean.sql"
      shift
      ;;
    --help)
      show_help
      exit 0
      ;;
    *)
      echo "Unknown option: $arg"
      show_help
      exit 1
      ;;
  esac
done

# Ask for connection details
read -p "Enter database host [localhost]: " DB_HOST
DB_HOST=${DB_HOST:-localhost}

read -p "Enter database port [5432]: " DB_PORT
DB_PORT=${DB_PORT:-5432}

if [ -n "$POSTGRES_USER" ]; then
  DB_USER="$POSTGRES_USER"
else
  read -p "Enter username [postgres]: " DB_USER
  DB_USER=${DB_USER:-postgres}
fi

if [ -n "$POSTGRES_PASSWORD" ]; then
  DB_PASSWORD="$POSTGRES_PASSWORD"
else
  read -s -p "Enter password: " DB_PASSWORD
  echo
fi

if [ -n "$POSTGRES_DB" ]; then
  DB_NAME="$POSTGRES_DB"
else
  read -p "Enter database name [postgres]: " DB_NAME
  DB_NAME=${DB_NAME:-postgres}
fi

echo "⏳ Exporting database '$DB_NAME' from $DB_HOST:$DB_PORT as user '$DB_USER' to $SQL_FILE..."

# Use PGPASSWORD for authentication
PGPASSWORD="$DB_PASSWORD" pg_dump \
  --host="$DB_HOST" \
  --port="$DB_PORT" \
  --username="$DB_USER" \
  --dbname="$DB_NAME" \
  > "$SQL_FILE"

echo "✅ Export completed."
