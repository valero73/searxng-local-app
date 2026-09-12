@echo off
setlocal EnableExtensions
cd /d "%~dp0"

where docker >nul 2>&1
if errorlevel 1 (
  echo Docker is not installed or not on PATH.
  echo Install Docker Desktop: https://docs.docker.com/desktop/setup/install/windows-install/
  exit /b 1
)

docker info >nul 2>&1
if errorlevel 1 (
  echo Docker is installed but not running. Start Docker Desktop and try again.
  exit /b 1
)

if not exist ".env" (
  powershell -NoProfile -Command ^
    "$bytes = New-Object byte[] 32; [System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes); $s = ([BitConverter]::ToString($bytes) -replace '-','').ToLower(); Set-Content -Path '.env' -Encoding ascii -Value ('SEARXNG_VERSION=latest' + [Environment]::NewLine + 'SEARXNG_PORT=8888' + [Environment]::NewLine + 'SEARXNG_BASE_URL=http://127.0.0.1:8888/' + [Environment]::NewLine + 'SEARXNG_SECRET=' + $s + [Environment]::NewLine)"
  echo Created .env with a new secret key.
)

if not exist "core-config" mkdir core-config

echo Starting SearXNG Local on http://127.0.0.1:8888/
docker compose up -d
if errorlevel 1 exit /b 1

echo.
echo Ready in a few seconds: http://127.0.0.1:8888/
echo JSON API: http://127.0.0.1:8888/search?q=privacy+search^&format=json
start "" "http://127.0.0.1:8888/"
endlocal
