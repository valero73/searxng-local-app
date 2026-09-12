# Agent install instructions

Goal: run a private SearXNG instance on the *current* machine at http://127.0.0.1:8888

## Preconditions

- Docker daemon running
- `docker compose` available
- Outbound network to pull `docker.io/searxng/searxng` and `docker.io/valkey/valkey`

## Steps

1. Clone or unpack this directory.
2. Run `./start.sh` (Unix) or `start.bat` (Windows).
3. Wait until `curl -fsS http://127.0.0.1:8888/` succeeds.
4. Search UI: `http://127.0.0.1:8888/`
5. JSON API: `http://127.0.0.1:8888/search?q=QUERY&format=json`

Do not bind to `0.0.0.0` unless the user explicitly asked to expose the instance.

Do not commit `.env`. The start scripts generate `SEARXNG_SECRET`.

## Verify

```bash
docker compose ps
curl -fsS "http://127.0.0.1:8888/search?q=test&format=json" | head -c 200
```

## Stop

```bash
./stop.sh
```
