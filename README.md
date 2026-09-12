# SearXNG Local App

Your own private search engine on `http://127.0.0.1:8888`.

It is [SearXNG](https://github.com/searxng/searxng): results from Google, Bing, DuckDuckGo, and 100+ other engines, with no ads, no profile, and no search log tied to you. Queries leave *this* machine as SearXNG talking to engines — not as “you in Chrome signed into Google.”

This folder is a **local app wrapper**. It is not a rewrite of SearXNG. It pins the official Docker image to localhost so you (or an agent) can start it with one script.

## What you need

- [Docker Desktop](https://docs.docker.com/get-docker/) on Windows or macOS, **or** Docker Engine + Compose on Linux
- About 512 MB RAM and a few hundred MB of disk for images

No account. No domain. Nothing is published to the internet unless you change the bind address.

## Run it

### Windows

1. Install and start Docker Desktop.
2. Unzip this folder anywhere.
3. Double-click `start.bat`.
4. Browser opens `http://127.0.0.1:8888`.

Stop with `stop.bat`.

### macOS / Linux

```bash
chmod +x start.sh stop.sh update.sh
./start.sh
```

Stop with `./stop.sh`.

### One-liner for a Grok / coding agent

```bash
git clone https://github.com/valero73/searxng-local-app.git
cd searxng-local-app
chmod +x start.sh stop.sh update.sh
./start.sh
```

Windows agent equivalent: clone, then run `start.bat`.

## Use it as a search API (for bots)

HTML UI:

```
http://127.0.0.1:8888/
```

JSON (no tracking, local only):

```bash
curl -s "http://127.0.0.1:8888/search?q=searxng&format=json"
```

Set this URL as a custom search engine in Firefox / Chrome if you want it as the default box.

## What this does *not* do

- It does **not** remotely install software on someone else’s PC. You (or an agent running *on that PC*) have to run the script there.
- It does **not** hide the fact that *some* machine queried Google/Bing. It hides *you* behind a self-hosted proxy with no account and no ads.
- Public sharing needs a reverse proxy, HTTPS, and a different bind address. This pack is locked to `127.0.0.1` on purpose.

## Update

```bash
./update.sh
```

or:

```bash
docker compose pull
docker compose up -d
```

## Files

| File | Purpose |
| --- | --- |
| `start.sh` / `start.bat` | Create `.env` secret, start containers, open the UI |
| `stop.sh` / `stop.bat` | Stop containers |
| `update.sh` | Pull latest official image |
| `docker-compose.yml` | Official `searxng/searxng` + Valkey cache |
| `core-config/settings.yml` | Local settings (JSON API on, limiter off) |
| `.env` | Generated on first start. Do not commit it |

Upstream project: [searxng/searxng](https://github.com/searxng/searxng) (AGPL-3.0).
