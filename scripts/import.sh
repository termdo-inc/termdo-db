#!/bin/bash
set -e

source .env
cat schema/dump.sql | sudo docker exec -i termdo-db psql --username="$POSTGRES_USER" --dbname="$POSTGRES_DB"
