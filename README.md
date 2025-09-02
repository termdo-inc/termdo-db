# Termdo DB

PostgreSQL database container, schema, and data snapshots for the Termdo system. Provides import/export scripts and a Compose setup that other microservices share via the `termdo-net` network.

This repo supports these services:

- termdo-auth-api: Auth accounts table
- termdo-tasks-api: Tasks table and relations
- termdo-gateway-api, termdo-web: Connect via network to this DB
- termdo-infra: Infra and deployment

## Features

- PostgreSQL 17 on Alpine base image
- Compose service with persistent volume at `./data/`
- Import and export scripts for schema and demo data
- Shared network `termdo-net` for cross-service connectivity

## Tech Stack

- Database: PostgreSQL 17 (official image)
- Orchestration: Docker Compose
- Scripts: Bash wrappers for `pg_dump` and `psql`

## Getting Started

### Prerequisites

- Docker and Docker Compose
- `.env` file with database credentials (see `.env.example`)

### Environment Variables

- `POSTGRES_USER`: Database user
- `POSTGRES_PASSWORD`: Database password
- `POSTGRES_DB`: Database name

Create a `.env` file from `.env.example` and fill values. The Compose service passes these into the Postgres container.

### Run with Docker Compose

```bash
docker compose up --build -d
```

Details:
- Service name: `db`
- Container name: `termdo-db`
- Data volume: `./data/ -> /var/lib/postgresql/data/`
- Network: `termdo-net` (shared with other Termdo services)

Note: The Compose file does not expose the Postgres port to the host. Other services on `termdo-net` connect by hostname.

## Connecting from Services

When running other services on the same `termdo-net` network:

- `POSTGRES_HOST=termdo-db` (container name) or `POSTGRES_HOST=db` (compose service name, if part of the same compose project)
- `POSTGRES_PORT=5432`
- `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB` as defined in this repo’s `.env`

Example `.env` for termdo-auth-api or termdo-tasks-api when sharing `termdo-net`:

```
DB_HOST=termdo-db
DB_PORT=5432
DB_USER=termdo_admin
DB_PASSWORD=change_me
DB_NAME=termdo
```

If you need host access (e.g., local `psql`), add a ports mapping to `compose.yaml`:

```yaml
services:
  db:
    ports:
      - "5432:5432"
```

## Schema

Tables used by Termdo services (see `schema/*.sql`):

- `account`:
  - `account_id` SERIAL PRIMARY KEY
  - `username` VARCHAR(32) UNIQUE NOT NULL
  - `password` VARCHAR(60) NOT NULL (bcrypt)

- `task`:
  - `task_id` SERIAL PRIMARY KEY
  - `account_id` INTEGER NOT NULL REFERENCES `account(account_id)` ON DELETE CASCADE
  - `title` VARCHAR(64) NOT NULL
  - `description` VARCHAR(1024)
  - `is_completed` BOOLEAN NOT NULL
  - `created_at` TIMESTAMPTZ NOT NULL DEFAULT NOW()
  - `updated_at` TIMESTAMPTZ NOT NULL DEFAULT NOW()

Files:
- `schema/clean.sql`: Schema only (no data)
- `schema/demo.sql`: Schema with empty data placeholders (or sanitized)
- `schema/dump.sql`: Live dump (may include demo/sample data)

## Import/Export

Scripts assume the container is named `termdo-db` and use the credentials from `.env`.

Export the current database:

```bash
# Default -> schema/dump.sql
./scripts/export.sh

# Schema-only -> schema/clean.sql
./scripts/export.sh --clean

# Demo dataset -> schema/demo.sql
./scripts/export.sh --demo
```

Import a snapshot into the running container:

```bash
# Default from schema/dump.sql
./scripts/import.sh

# Schema only
./scripts/import.sh --clean

# Demo dataset
./scripts/import.sh --demo
```

Note: If you see permission errors, ensure the container is running and your user can run Docker commands (scripts call `docker exec`).

## Backups & Data

- Volume-backed data lives in `./data/` on the host.
- Use export scripts to snapshot logical backups into `schema/*.sql`.
- For restoration, import the desired snapshot while the DB service is running.

## Integration Notes

- Start this DB first, then start `termdo-auth-api` and `termdo-tasks-api` so they can connect.
- All services should join the same `termdo-net` network (Compose files already do this).

## License

MIT — see `LICENSE.md`.

```sh
test
```
