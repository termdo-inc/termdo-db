#!/bin/bash
set -e

source .env

# Default output file
SQL_FILE="schema/dump.sql"

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
      SQL_FILE="schema/demo.sql"
      shift
      ;;
    --clean)
      SQL_FILE="schema/clean.sql"
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

echo "⏳ Exporting database '$POSTGRES_DB' to $SQL_FILE..."

sudo docker exec termdo-db pg_dump --username="$POSTGRES_USER" --dbname="$POSTGRES_DB" > "$SQL_FILE"

echo "✅ Export completed."
