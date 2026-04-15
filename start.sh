#!/usr/local/bin/bash

set -eu

APP_DIR="${APP_DIR:-$(cd "$(dirname "$0")" && pwd)}"
APP_NAME="${APP_NAME:-sub2api}"
SESSION_NAME="${SESSION_NAME:-sub2api}"
LOG_FILE="${LOG_FILE:-${APP_DIR}/start.log}"

echo "Stopping old process..."
pkill -9 -f "${APP_NAME}" 2>/dev/null || true
sleep 1

echo "Starting ${APP_NAME} in screen session ${SESSION_NAME}..."
echo "App dir: ${APP_DIR}"
screen -wipe > /dev/null 2>&1 || true
screen -S "${SESSION_NAME}" -X quit > /dev/null 2>&1 || true

screen -dmS "${SESSION_NAME}" /usr/local/bin/bash -lc "
  cd '${APP_DIR}'
  set -a
  source ./.env
  set +a
  exec ./'${APP_NAME}' >> '${LOG_FILE}' 2>&1
"

sleep 3
if pgrep -f "${APP_NAME}" > /dev/null; then
  echo \"${APP_NAME} started successfully.\"
  echo \"Attach screen: screen -r ${SESSION_NAME}\"
  echo \"Startup log: ${LOG_FILE}\"
else
  echo \"${APP_NAME} failed to start.\"
  echo \"Check log: ${LOG_FILE}\"
  exit 1
fi
