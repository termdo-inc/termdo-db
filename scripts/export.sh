#!/bin/bash
set -e

source .env
sudo docker exec termdo-db pg_dump --username="$POSTGRES_USER" --dbname="$POSTGRES_DB" > schema/dump.sql
