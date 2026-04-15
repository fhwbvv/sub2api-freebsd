#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FRONTEND_DIR="${ROOT_DIR}/frontend"
BACKEND_DIR="${ROOT_DIR}/backend"
DIST_DIR="${ROOT_DIR}/dist"
VERSION="${VERSION:-dev}"
OUTPUT_NAME="${OUTPUT_NAME:-sub2api-freebsd-amd64}"

echo "[1/3] Building frontend assets"
cd "${FRONTEND_DIR}"
corepack enable
pnpm install --frozen-lockfile
pnpm run build

echo "[2/3] Building FreeBSD binary"
cd "${BACKEND_DIR}"
printf '%s\n' "${VERSION#v}" > cmd/server/VERSION
mkdir -p "${DIST_DIR}"
CGO_ENABLED=0 GOOS=freebsd GOARCH=amd64 \
  go build -tags embed -ldflags="-s -w -X main.Version=${VERSION#v}" -trimpath \
  -o "${DIST_DIR}/${OUTPUT_NAME}" ./cmd/server

echo "[3/3] Build complete"
echo "Output: ${DIST_DIR}/${OUTPUT_NAME}"
