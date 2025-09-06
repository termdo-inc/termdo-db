#!/bin/bash
set -e

# Get env variables from .env file if it exists
if [ -f .env ]; then
  source .env
fi

# Default SQL file
SQL_FILE="schema/dump.sql"

show_help() {
  echo "Usage: $0 [--clean | --demo | --help]"
  echo
  echo "Options:"
  echo "  --clean     Import 'clean.sql' (schema only, no data)"
  echo "  --demo      Import 'demo.sql' (schema + dummy data)"
  echo "  --help      Show this help message"
  echo
  echo "If no flag is provided, 'dump.sql' will be used by default."
}

# Parse arguments
for arg in "$@"; do
  case $arg in
    --clean)
      SQL_FILE="schema/clean.sql"
      shift
      ;;
    --demo)
      SQL_FILE="schema/demo.sql"
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

echo "⏳ Importing $SQL_FILE into database '$DB_NAME' on $DB_HOST:$DB_PORT as user '$DB_USER'..."

PGPASSWORD="$DB_PASSWORD" psql \
  --host="$DB_HOST" \
  --port="$DB_PORT" \
  --username="$DB_USER" \
  --dbname="$DB_NAME" \
  < "$SQL_FILE"

echo "✅ Import completed."
