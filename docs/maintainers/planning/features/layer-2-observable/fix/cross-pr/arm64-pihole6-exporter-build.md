# Fix batch: arm64-pihole6-exporter-build

**Feature:** Layer 2 Observable (learning spike)  
**Type:** Cross-PR (Pi deploy blocker)  
**Status:** ✅ Complete  
**Completed:** 2026-06-04  
**Branch:** `fix/arm64-pihole6-exporter-build`

---

## Problem

`docker compose pull` on Raspberry Pi (linux/arm64) fails:

```text
Error response from daemon: no matching manifest for linux/arm64/v8 in the manifest list entries
```

Image: `ghcr.io/mosher-labs/pihole6-exporter:latest` — GHCR publish is **amd64-only** despite desk notes assuming multi-arch.

---

## Fix

| Change | Rationale |
|--------|-----------|
| `docker/pihole6-exporter/Dockerfile` | Build Mosher-Labs script on Pi (python:3.14-alpine, pinned commit) |
| `docker-compose.yml` | `build: ./docker/pihole6-exporter`, image `pihole-dns/pihole6-exporter:spike` |
| Docs / manual-testing / Task 15 | `docker compose build pihole-exporter` before `pull` / `up` |

Same exporter metrics (`pihole_query_type_1m`, etc.) — no dashboard/alert changes.

---

## Issues fixed

- **L2-ARM64-#1:** GHCR Mosher image lacks arm64 manifest (HIGH, LOW effort) — local build delivery

---

## Testing

- [x] `docker compose config` validates
- [ ] Pi: `docker compose build pihole-exporter && docker compose up -d` (operator — Group 4 Task 15)

---

## Related

- **Spike outcomes:** `spike-outcomes.md` § Group 2 handoff
- **Deploy tasks:** `tasks/04-deploy-and-incident-walkthrough.md` Task 15
