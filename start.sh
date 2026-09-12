#!/usr/bin/env bash
# Start the local SearXNG app (macOS / Linux). Requires Docker Desktop or Docker Engine + Compose.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

PORT="${SEARXNG_PORT:-8888}"
URL="http://127.0.0.1:${PORT}/"

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1"
    echo "Install Docker Desktop: https://docs.docker.com/get-docker/"
    exit 1
  fi
}

need_cmd docker

if ! docker info >/dev/null 2>&1; then
  echo "Docker is installed but the daemon is not running."
  echo "Start Docker Desktop (or the docker service) and run this script again."
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "Docker Compose plugin is missing. Install Docker Desktop or the compose plugin."
  exit 1
fi

if [[ ! -f .env ]]; then
  SECRET="$(python3 -c 'import secrets; print(secrets.token_hex(32))' 2>/dev/null \
    || openssl rand -hex 32 2>/dev/null \
    || head -c 32 /dev/urandom | od -An -tx1 | tr -d ' \n')"
  cat > .env <<EOF
SEARXNG_VERSION=latest
SEARXNG_PORT=${PORT}
SEARXNG_BASE_URL=${URL}
SEARXNG_SECRET=${SECRET}
EOF
  echo "Created .env with a new secret key."
fi

mkdir -p core-config
if [[ ! -f core-config/settings.yml ]]; then
  echo "Missing core-config/settings.yml"
  exit 1
fi

echo "Starting SearXNG Local on ${URL}"
docker compose up -d

echo
echo "Waiting for the search UI..."
for i in $(seq 1 30); do
  if curl -fsS "${URL}" >/dev/null 2>&1; then
    echo "Ready: ${URL}"
    echo "JSON API example:"
    echo "  curl -s '${URL}search?q=privacy+search&format=json' | head"
    if command -v open >/dev/null 2>&1; then
      open "${URL}" || true
    elif command -v xdg-open >/dev/null 2>&1; then
      xdg-open "${URL}" || true
    fi
    exit 0
  fi
  sleep 1
done

echo "Containers started, but the UI is not answering yet. Check:"
echo "  docker compose logs -f searxng"
exit 0
