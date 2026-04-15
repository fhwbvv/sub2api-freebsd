# FreeBSD Binary Deployment with Environment Variables

This document describes how to run the FreeBSD-only build from `fhwbvv/sub2api-freebsd` without Docker Compose.

## Example `.env`

```dotenv
AUTO_SETUP=true

SERVER_HOST=127.0.0.1
SERVER_PORT=38708
SERVER_MODE=release
RUN_MODE=simple
TZ=Asia/Shanghai
GIN_MODE=release

SETUP_MIGRATION_TIMEOUT_SECONDS=1800

DATABASE_HOST=127.0.0.1
DATABASE_PORT=5432
DATABASE_USER=your_pg_user
DATABASE_PASSWORD=your_pg_password
DATABASE_DBNAME=sub2api
DATABASE_SSLMODE=disable

REDIS_HOST=127.0.0.1
REDIS_PORT=6379
REDIS_PASSWORD=
REDIS_DB=0
REDIS_ENABLE_TLS=false

ADMIN_EMAIL=admin@example.com
ADMIN_PASSWORD=your_admin_password

JWT_SECRET=replace-with-a-long-random-secret
JWT_EXPIRE_HOUR=24
```

## Start Command

The binary does not read `.env` automatically. Load the environment into the current shell first:

```bash
set -a && source ./.env && set +a && ./sub2api-freebsd-amd64
```

If you rename the binary to `sub2api`, use:

```bash
set -a && source ./.env && set +a && ./sub2api
```

## `start.sh`

This repository also includes a generic `start.sh` helper script for FreeBSD environments with `screen`.

It automatically:

- uses the directory where `start.sh` is located as `APP_DIR`
- loads `.env`
- starts the app inside a detached `screen` session
- writes output to `start.log`

Usage:

```bash
chmod +x ./start.sh
./start.sh
```

Optional overrides:

```bash
APP_DIR=/your/app/path APP_NAME=sub2api SESSION_NAME=sub2api ./start.sh
```

## Notes

- `AUTO_SETUP=true` enables first-run initialization from environment variables.
- `SETUP_MIGRATION_TIMEOUT_SECONDS=1800` is recommended for slower PostgreSQL migrations.
- PostgreSQL and Redis must already be reachable before startup.
- After the first successful startup, the program will generate `config.yaml` and `.installed` in the working directory.
