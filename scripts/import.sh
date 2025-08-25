#!/bin/bash
set -e

source .env

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

echo "⏳ Importing $SQL_FILE into database '$POSTGRES_DB'..."

cat "$SQL_FILE" | sudo docker exec -i termdo-db psql --username="$POSTGRES_USER" --dbname="$POSTGRES_DB"

echo "✅ Import completed."
